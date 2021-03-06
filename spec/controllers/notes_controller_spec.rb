require 'rails_helper'

RSpec.describe NotesController, type: :controller do
  describe "notes#index action" do
		it "should successfully respond" do
		  get :index
      expect(response).to have_http_status(:success)
		end
	end

  describe "notes#create action" do
    before do
      post :create, params: { note: { title:"First", content:"Hello" } }
    end
    it "should return 200 status code" do
      expect(response).to be_success
    end

    it "should successfully create and save a new note in the database" do
      note = Note.last
      expect(note.content).to eq('Hello')
      expect(note.title).to eq('First')
    end

    it "should return the created note in the response body" do
      json = JSON.parse(response.body)
      expect(json['content']).to eq('Hello')
      expect(json['title']).to eq('First')
    end
  end

  describe "notes#create action validations" do
  before do
    post :create, params: { note: { title: '', content: '' } }
  end

  it "should properly deal with validation errors" do
    expect(response).to have_http_status(:unprocessable_entity)
  end

  it "should return error json on validation error" do
    json = JSON.parse(response.body)
    expect(json["errors"]["content"][0]).to eq("can't be blank")
    expect(json["errors"]["title"][0]).to eq("can't be blank")
  end
end
  
end
