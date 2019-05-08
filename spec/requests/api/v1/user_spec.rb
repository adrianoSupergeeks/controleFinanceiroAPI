require 'rails_helper'

RSpec.describe 'Users API', type: :request do
    let!(:user) { create(:user) }
    let(:user_id) { user.id }
    
    before { host! "localhost:3000/api" }
    
    describe "GET user/:id" do
        
        before do
            headers = { "Accept" => "application/vnd.projetofase8.v1" }
            get "/users/#{user_id}", params: {}, headers: headers
        end
        
        context "quando o usuario existir" do
            it "retorna o usuario" do
                    user_response = JSON.parse(response.body)
                expect(user_response["id"]).to eq(user_id)
            end
            it "retorna codigo de status 200" do
                expect(response).to have_http_status(200) 
            end
        end
        
        context "Quando o usuario não existir" do
            let(:user_id) { 10000 }
            
            it "retorna codigo de status 404" do
                expect(response).to have_http_status(404)
            end
        end
        
    end
    
    describe "Post user/" do
        
        before do
            headers = { "Accept" => "application/vnd.projetofase8.v1" }
            post "/users", params: { user: user_params }, headers: headers
        end 
        
        context "quando a requisicao eh valida" do
            let(:user_params) { attributes_for(:user) }
            
            it "retorna codigo de status 201" do
                expect(response).to have_http_status(201) 
            end
            
            it "retorna o json para o usuario criado" do
                user_response = JSON.parse(response.body)
                expect(json_body['email']).to eq(user_params[:email])
            end
        end
        
        context "quando a requisicao eh invalida" do
            let(:user_params) { attributes_for(:user, email: "email_invalido@") }
            
            it "retorna codigo de status 422" do
                expect(response).to have_http_status(422) 
            end
            
            it "retorna o jsonpara os erros" do
                user_response = JSON.parse(response.body)
                expect(json_body).to have_key('errors')
            end
        end
    end
end
