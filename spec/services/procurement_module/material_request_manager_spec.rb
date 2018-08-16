RSpec.describe ProcurementModule::MaterialRequestManager, type: :service do
  let(:user) { FactoryBot.create(:user, :admin) }
  let(:sales_order_item) { FactoryBot.create(:sales_order_item) }

  describe '.create!' do
    context 'Sales Order item not found' do
      it 'should raise RecordNotFound error' do
        shortages = [ { sales_order_item_id: sales_order_item.id + 10, unavailable_quantity: 10 } ]
        expect{ ProcurementModule::MaterialRequestManager.create!(
          current_user: user,
          shortages: shortages
        ) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'Sales Order item is processed' do
      it 'should raise ValidationFailed error' do
        sales_order_item.processed!
        unavailable_quantity = rand(1...sales_order_item.quantity)
        shortages = [ { sales_order_item_id: sales_order_item.id, unavailable_quantity: unavailable_quantity } ]
        expect{ ProcurementModule::MaterialRequestManager.create!(
          current_user: user,
          shortages: shortages
        ) }.to raise_error(ValidationFailed, 'Material request cannot be created after sales order item is processed')
      end
    end

    context 'Unavailable Quantity is more than Ordered quantity' do
      it 'should raise ValidationFailed error' do
        unavailable_quantity = sales_order_item.quantity + 1
        shortages = [ { sales_order_item_id: sales_order_item.id, unavailable_quantity: unavailable_quantity } ]
        expect{ ProcurementModule::MaterialRequestManager.create!(
          current_user: user,
          shortages: shortages
        ) }.to raise_error(ValidationFailed, 'Unavailable Quantity cannot be more than ordered quantity')
      end
    end

    # TODO [nipunmanocha] Write this test when the logic is implemented
    context 'Inventory is available for the SKU' do
      xit 'should raise ValidationFailed error' do

      end
    end

    context 'No existing MR for current sku' do
      it 'should create a new MR' do
        old_mr_count = MaterialRequest.count
        unavailable_quantity = rand(1...sales_order_item.quantity)
        shortages = [ { sales_order_item_id: sales_order_item.id, unavailable_quantity: unavailable_quantity } ]
        ProcurementModule::MaterialRequestManager.create!(current_user: user, shortages: shortages)

        created_mr = MaterialRequest.last

        expect(MaterialRequest.count).to eq(old_mr_count + 1)
        expect(created_mr.sku).to eq(sales_order_item.sku)
        expect(created_mr.quantity).to eq(unavailable_quantity)
        expect(created_mr.sales_order_items.last).to eq(sales_order_item)
        expect(sales_order_item.material_requests.last).to eq(created_mr)
      end
    end

    context 'MR for the SKU is already present in draft state' do
      it 'should not create a new MR' do
        existing_mr = FactoryBot.create(:material_request, sku: sales_order_item.sku, user: user)
        old_quantity = existing_mr.quantity
        old_mr_count = MaterialRequest.count

        unavailable_quantity = rand(1...sales_order_item.quantity)
        shortages = [ { sales_order_item_id: sales_order_item.id, unavailable_quantity: unavailable_quantity } ]
        ProcurementModule::MaterialRequestManager.create!(current_user: user, shortages: shortages)

        expect(MaterialRequest.count).to eq(old_mr_count)
        expect(existing_mr.sales_order_items.last).to eq(sales_order_item)
        expect(sales_order_item.material_requests.last).to eq(existing_mr)
        expect(sales_order_item.material_requests.last.quantity).to eq(old_quantity + unavailable_quantity)
      end
    end

    context 'Error in one of the hash in shortages array' do
      it 'should rollback the complete process' do
        sales_order_item_2 = FactoryBot.create(:sales_order_item, status: :processed)
        old_mr_count = MaterialRequest.count

        unavailable_quantity = rand(1...sales_order_item.quantity)

        # One valid and one invalid hash
        shortages = [ { sales_order_item_id: sales_order_item.id, unavailable_quantity: unavailable_quantity },
                      { sales_order_item_id: sales_order_item_2.id, unavailable_quantity: 2 } ]

        expect{ ProcurementModule::MaterialRequestManager.create!(
          current_user: user,
          shortages: shortages
        ) }.to raise_error(ValidationFailed, 'Material request cannot be created after sales order item is processed')
        expect(MaterialRequest.count).to eq(old_mr_count)
      end
    end
  end
end
