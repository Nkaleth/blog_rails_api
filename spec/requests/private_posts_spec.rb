# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Posts with authentication', type: :request  do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:user_post) { create(:post, :user_id, user.id) }
  let(:other_user_post) { create(:post, user_id: other_user.id, published: true) }
  let(:other_user_post_draft) { create(:post, user_id: other_user.id, published: false) }
  let!(:auth_headers)  { { 'Authorization' => "Bearer #{user.auth_token}" } }
  let!(:other_auth_headers) { { 'Authorization' => "Bearer #{other_user.auth_token}" } }
  let!(:create_params) { { "post" => { "title" => "title", "content" => "content", "published" => true } } }

  describe "GET /posts/{id}" do
    context "with valid auth" do
      context "when requesting other's author post" do
        context "When post is public" do
          before { get "/posts/#{other_user_post.id}", headers: auth_headers }

          context "Payload" do
            subject { payload }
            it { is_expected.to include(:id) }
          end
          context "Response" do
            subject { response }
            it { is_expected.to have_http_status(:ok) }
          end
        end
        context "When post is draft" do
          before { get "/posts/#{other_user_post_draft.id}", headers: auth_headers }

          context "Payload" do
            subject { payload }
            it { is_expected.to include(:error) }
          end
          context "Response" do
            subject { response }
            it { is_expected.to have_http_status(:not_found) }
          end
        end
      end
      context "when requesting user's post" do
      end
    end
  end

   describe "POST /posts" do
    context "with valid auth" do
      before { post "/posts", params: create_params, headers: auth_headers }

      context "Payload" do
        subject { payload }
        it { is_expected.to include(:id, :title, :content, :published, :author) }
      end
      context "Response" do
        subject { response }
        it { is_expected.to have_http_status(:created) }
      end
    end

    context "withuot authentication" do
      before { post "/posts", params: create_params  }

      context "Payload" do
        subject { payload }
        it { is_expected.to include(:error) }
      end
      context "Response" do
        subject { response }
        it { is_expected.to have_http_status(:unauthorized) }
      end
    end
  end

  describe "PUT /posts" do
  end

  private

  def payload
    JSON.parse(response.body).with_indifferent_access
  end
end
