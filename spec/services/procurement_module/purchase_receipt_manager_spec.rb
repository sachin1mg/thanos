RSpec.describe ProcurementModule::PurchaseReceiptManager, type: :service do
  let(:sku) { FactoryBot.create(:sku) }
  let(:sku2) { FactoryBot.create(:sku) }

  let(:purchase_order_item1) { FactoryBot.create(:purchase_order_item, sku: sku) }
  let(:purchase_order_item2) { FactoryBot.create(:purchase_order_item, sku: sku) }
  let(:purchase_order_item3) { FactoryBot.create(:purchase_order_item, sku: sku2, 
                                                  purchase_order: purchase_order_item1.purchase_order) }

  let(:purchase_order_ids) { [purchase_order_item1.purchase_order.id, purchase_order_item2.purchase_order.id] }
  let(:desired_quantity_sku) { purchase_order_item1.quantity + purchase_order_item2.quantity }
  let(:desired_quantity_sku2) { purchase_order_item3.quantity }

  describe '.verify_uploaded_data' do
    context 'Unknown sku' do
      it 'should populate unavailable array in result' do
        sku.save!
        sku_quantities = [ { sku_id: (Sku.last.id + 100), quantity: 100 } ]
        expected_result = {
          unavailable: [ { sku_id: (Sku.last.id + 100), quantity: 100 } ],
          shortages: [],
          extra: [],
          not_in_po: [],
          fulfilled: []
        }

        result = ProcurementModule::PurchaseReceiptManager.verify_uploaded_data(
                  purchase_order_ids: purchase_order_ids,
                  sku_quantities: sku_quantities)

        expect(result).to eq(expected_result)
      end
    end

    context 'Known SKU but not present in POs' do
      it 'should populate not_in_po array in result' do
        sku2 = FactoryBot.create(:sku)
        sku_quantities = [ { sku_id: sku2.id, quantity: 100 } ]
        expected_result = {
          unavailable: [],
          shortages: [],
          extra: [],
          not_in_po: [ { sku_id: sku2.id, quantity: 100 } ],
          fulfilled: []
        }

        result = ProcurementModule::PurchaseReceiptManager.verify_uploaded_data(
          purchase_order_ids: purchase_order_ids,
          sku_quantities: sku_quantities)

        expect(result).to eq(expected_result)
      end
    end

    context 'Exact quantity provided' do
      it 'should populate only the fulfilled array in result' do
        sku_quantities = [ { sku_id: sku.id, quantity: desired_quantity_sku } ]
        expected_result = {
          unavailable: [],
          shortages: [],
          extra: [],
          not_in_po: [],
          fulfilled: [ { sku_id: sku.id, quantity: desired_quantity_sku } ]
        }

        result = ProcurementModule::PurchaseReceiptManager.verify_uploaded_data(
          purchase_order_ids: purchase_order_ids,
          sku_quantities: sku_quantities)

        expect(result).to eq(expected_result)
      end
    end

    context 'Extra quantity provided' do
      it 'should populate fulfilled and extra arrays in result' do
        extra_quantity = 20
        sku_quantities = [ { sku_id: sku.id, quantity: desired_quantity_sku + extra_quantity } ]
        expected_result = {
          unavailable: [],
          shortages: [],
          extra: [ { sku_id: sku.id, quantity: extra_quantity } ],
          not_in_po: [],
          fulfilled: [ { sku_id: sku.id, quantity: desired_quantity_sku } ]
        }

        result = ProcurementModule::PurchaseReceiptManager.verify_uploaded_data(
          purchase_order_ids: purchase_order_ids,
          sku_quantities: sku_quantities)

        expect(result).to eq(expected_result)
      end
    end

    context 'Shortage in quantity' do
      it 'should populate fulfilled and shortage array in result' do
        short_quantity = 5
        sku_quantities = [ { sku_id: sku.id, quantity: desired_quantity_sku - short_quantity } ]
        expected_result = {
          unavailable: [],
          shortages: [ { sku_id: sku.id, quantity: short_quantity } ],
          extra: [],
          not_in_po: [],
          fulfilled: [ { sku_id: sku.id, quantity: desired_quantity_sku - short_quantity } ]
        }

        result = ProcurementModule::PurchaseReceiptManager.verify_uploaded_data(
          purchase_order_ids: purchase_order_ids,
          sku_quantities: sku_quantities)

        expect(result).to eq(expected_result)
      end
    end

    context 'Combination of 2 SKUs' do
      context 'sku: exact and sku2: extra' do
        it 'should populate extra and fulfilled' do
          sku_quantities = [ { sku_id: sku.id, quantity: desired_quantity_sku },
                             { sku_id: sku2.id, quantity: desired_quantity_sku2 + 15 } ]
                    
          expected_result = {
            unavailable: [],
            shortages: [],
            extra: [ { sku_id: sku2.id, quantity: 15 } ],
            not_in_po: [],
            fulfilled: [ { sku_id: sku.id, quantity: desired_quantity_sku },
                         { sku_id: sku2.id, quantity: desired_quantity_sku2 } ]
          }
  
          result = ProcurementModule::PurchaseReceiptManager.verify_uploaded_data(
            purchase_order_ids: purchase_order_ids,
            sku_quantities: sku_quantities)
  
          expect(result).to eq(expected_result)
        end
      end

      context 'sku: shortage and sku2: extra' do
        it 'should populate shortage, extra and fulfilled' do
          sku_quantities = [ { sku_id: sku.id, quantity: desired_quantity_sku - 5 },
                             { sku_id: sku2.id, quantity: desired_quantity_sku2 + 15 } ]
                    
          expected_result = {
            unavailable: [],
            shortages: [ { sku_id: sku.id, quantity: 5 } ],
            extra: [ { sku_id: sku2.id, quantity: 15 } ],
            not_in_po: [],
            fulfilled: [ { sku_id: sku.id, quantity: desired_quantity_sku - 5 },
                         { sku_id: sku2.id, quantity: desired_quantity_sku2 } ]
          }
  
          result = ProcurementModule::PurchaseReceiptManager.verify_uploaded_data(
            purchase_order_ids: purchase_order_ids,
            sku_quantities: sku_quantities)
  
          expect(result).to eq(expected_result)
        end
      end

      context 'sku: shortage, sku2: extra, sku3: unavailable' do
        it 'should populate unavailable, shortage, extra and fulfilled' do
          sku_quantities = [ { sku_id: sku.id, quantity: desired_quantity_sku - 5 },
                             { sku_id: sku2.id, quantity: desired_quantity_sku2 + 15 },
                             { sku_id: (Sku.last.id + 100), quantity: 100 } ]
                    
          expected_result = {
            unavailable: [ { sku_id: (Sku.last.id + 100), quantity: 100 } ],
            shortages: [ { sku_id: sku.id, quantity: 5 } ],
            extra: [ { sku_id: sku2.id, quantity: 15 } ],
            not_in_po: [],
            fulfilled: [ { sku_id: sku.id, quantity: desired_quantity_sku - 5 },
                         { sku_id: sku2.id, quantity: desired_quantity_sku2 } ]
          }
  
          result = ProcurementModule::PurchaseReceiptManager.verify_uploaded_data(
            purchase_order_ids: purchase_order_ids,
            sku_quantities: sku_quantities)
  
          expect(result).to eq(expected_result)
        end
      end

      context 'sku: shortage, sku2: extra, sku3: not in PO, sku4: unavailable' do
        it 'should populate all the arrays in result' do
          sku3 = FactoryBot.create(:sku)
          sku_quantities = [ { sku_id: sku.id, quantity: desired_quantity_sku - 5 },
                             { sku_id: sku2.id, quantity: desired_quantity_sku2 + 15 },
                             { sku_id: sku3.id, quantity: 100 },
                             { sku_id: (Sku.last.id + 100), quantity: 100 } ]
                    
          expected_result = {
            unavailable: [ { sku_id: (Sku.last.id + 100), quantity: 100 } ],
            shortages: [ { sku_id: sku.id, quantity: 5 } ],
            extra: [ { sku_id: sku2.id, quantity: 15 } ],
            not_in_po: [ { sku_id: sku3.id, quantity: 100 } ],
            fulfilled: [ { sku_id: sku.id, quantity: desired_quantity_sku - 5 },
                         { sku_id: sku2.id, quantity: desired_quantity_sku2 } ]
          }
  
          result = ProcurementModule::PurchaseReceiptManager.verify_uploaded_data(
            purchase_order_ids: purchase_order_ids,
            sku_quantities: sku_quantities)
  
          expect(result).to eq(expected_result)
        end
      end
    end
  end
end
