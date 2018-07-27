require 'rails_helper'

RSpec.describe SecretsController, type: :controller do
  context "given an existing secret" do
    let!(:secret) { create(:secret) }

    describe "POST #create" do
      let(:public_key) { '02' * 33 }

      it "returns http created and formats using serializer if format: json" do
        post :create, params: { public_key: public_key, format: :json }
        expect(response).to have_http_status(:created)
        expect(assigns(:secret).public_key).to eq public_key
        assert_serializer 'SecretSerializer'
      end

      it "redirects to show if format: html" do
        post :create, params: { public_key: public_key, format: :html }
        expect(response).to redirect_to action: :show, id: assigns(:secret).uuid
      end
    end

    describe "GET #show" do
      it "returns http success and formats using serializer if format: json" do
        get :show, params: { id: secret.uuid, format: :json }
        expect(response).to have_http_status(:success)
        expect(assigns(:secret)).to eq secret
        assert_serializer 'SecretSerializer'
      end

      it "renders new.html if format: html" do
        get :show, params: { id: secret.uuid, format: :html }
        expect(response).to render_template(:show)
      end
    end

    describe "PUT #update" do
      it "updates and seals secret, returns format using serializer if format: json" do
        expect do
          put :update, params: { id: secret.uuid, encrypted_data: 'foobar', format: :json }
        end.to change { secret.reload.sealed? }.to true

        expect(response).to have_http_status(:success)
        expect(assigns(:secret)).to eq secret
        assert_serializer 'SecretSerializer'
      end

      it "redirects to show if format: html" do
        put :update, params: { id: secret.uuid, encrypted_data: 'foobar', format: :html }
        expect(response).to redirect_to action: :show, id: secret.uuid
      end
    end
  end

  # describe "POST #create_signature" do
  #   let(:request_params) do
  #     { id: proposal.id, parts: TransactionService.new(proposal: proposal).sign(xpriv1) }
  #   end

  #   it_behaves_like :authenticated_endpoint, -> { post :create_signature }

  #   it "returns http success and adds new signature to proposal" do
  #     expect { post :create_signature }
  #       .to change { proposal.signatures.count }.by(1)

  #     expect(response).to have_http_status(:created)
  #     expect(assigns(:signature)).to eq proposal.signatures.last
  #     assert_response_schema
  #   end
  # end
end
