require 'rails_helper'

RSpec.describe "Cheques API", type: :request do
  let(:cliente) { create(:cliente) }
  let(:bordero) { create(:bordero, cliente: cliente) }
  let!(:cheque) { create(:cheque, bordero: bordero) }

  describe "GET /cheques" do
    it "returns all cheques" do
      get cheques_path
      
      expect(response).to have_http_status(:success)
      json_response = JSON.parse(response.body)
      expect(json_response).not_to be_empty
    end
  end

  describe "GET /cheques/:id" do
    it "returns the cheque" do
      get cheque_path(cheque)
      
      expect(response).to have_http_status(:success)
      json_response = JSON.parse(response.body)
      expect(json_response["id"]).to eq(cheque.id)
      expect(json_response["holder"]).to eq(cheque.holder)
    end
  end

  describe "POST /cheques" do
    let(:valid_attributes) do
      {
        bordero_id: bordero.id,
        holder: "Pedro Oliveira",
        valor_cheque: "1500.50",
        data_vencimento: Date.today + 45.days,
        bank: "Itaú",
        numero_agencia: "5678-9",
        numero_cheque: "000002",
        dias_compensacao: 2
      }
    end

    it "creates a new cheque" do
      expect {
        post cheques_path, params: { cheque: valid_attributes }
      }.to change(Cheque, :count).by(1)

      expect(response).to have_http_status(:created)
      json_response = JSON.parse(response.body)
      expect(json_response["holder"]).to eq("Pedro Oliveira")
      expect(json_response["valor_cheque"]).to eq("1500.5")
    end

    context "with invalid parameters" do
      it "does not create a cheque" do
        expect {
          post cheques_path, params: { cheque: { holder: "Teste" } }
        }.not_to change(Cheque, :count)

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH /cheques/:id" do
    it "updates the cheque" do
      patch cheque_path(cheque), params: { cheque: { holder: "Maria Santos Atualizada" } }

      expect(response).to have_http_status(:success)
      cheque.reload
      expect(cheque.holder).to eq("Maria Santos Atualizada")
    end
  end

  describe "DELETE /cheques/:id" do
    it "destroys the cheque" do
      expect {
        delete cheque_path(cheque)
      }.to change(Cheque, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end
  end

  describe "Calculations" do
    describe "#dias_a_decorrer" do
      it "calculates dias_a_decorrer correctly" do
        cheque = create(:cheque,
          bordero: bordero,
          data_vencimento: bordero.data_troca + 30.days,
          dias_compensacao: 2
        )

        # 30 dias - 2 dias de compensação = 28 dias
        expect(cheque.dias_a_decorrer).to eq(28)
      end
    end

    describe "#valor_juros" do
      it "calculates valor_juros correctly" do
        cheque = create(:cheque,
          bordero: bordero,
          valor_cheque: BigDecimal("1000.00"),
          data_vencimento: bordero.data_troca + 30.days,
          dias_compensacao: 0
        )

        # Com juros de 2.5% ao mês e 30 dias
        expect(cheque.valor_juros).to be > 0
        expect(cheque.valor_juros).to be_a(BigDecimal)
      end
    end

    describe "#valor_iof" do
      it "calculates valor_iof correctly" do
        cheque = create(:cheque,
          bordero: bordero,
          valor_cheque: BigDecimal("1000.00"),
          data_vencimento: bordero.data_troca + 30.days,
          dias_compensacao: 0
        )

        iof = cheque.valor_iof
        expect(iof).to be > 0
        expect(iof).to be_a(BigDecimal)
        
        # IOF deve estar entre limites razoáveis (0.38% + dias * 0.0082%)
        expect(iof).to be < cheque.valor_cheque * BigDecimal("0.01")
      end
    end

    describe "#valor_receber" do
      it "calculates valor_receber correctly" do
        cheque = create(:cheque,
          bordero: bordero,
          valor_cheque: BigDecimal("1000.00"),
          data_vencimento: bordero.data_troca + 30.days,
          dias_compensacao: 0
        )

        valor_receber = cheque.valor_receber
        
        # Valor a receber deve ser menor que o valor do cheque
        expect(valor_receber).to be < cheque.valor_cheque
        
        # Deve ser igual a: valor_cheque - juros - iof
        expected = cheque.valor_cheque - cheque.valor_juros - cheque.valor_iof
        expect(valor_receber).to eq(expected)
      end
    end
  end
end
