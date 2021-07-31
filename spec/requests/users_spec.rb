require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe 'GET #index' do
    subject { get(users_path) }
    context 'ユーザーが存在するとき' do
      before { create_list(:user, 3) }
      it 'リクエストが成功する' do
        subject
        expect(response).to have_http_status(:ok)
      end

      it 'nameが表示されている' do
        subject
        expect(response.body).to include(*User.pluck(:name))
      end
    end
  end

  describe 'GET #show' do
    subject { get(user_path(user.id)) }
    context 'ユーザーが存在するとき' do
      let(:user) { create(:user) }
      let(:user_id) { user.id }

      it 'リクエストが成功する' do
        subject
        expect(response).to have_http_status(:ok)
      end

      it 'nameが表示されている' do
        subject
        expect(response.body).to include user.name
      end

      it 'ageが表示されている' do
        subject
        expect(response.body).to include user.age.to_s
      end

      it 'emailが表示されている' do
        subject
        expect(response.body).to include user.email
      end
    end
  end

  describe 'GET #new' do
    it 'リクエストが成功する' do
      get(new_user_path)
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST #create' do
    subject { post(users_path, params: params) }
    context 'パラメータが正常なとき' do
      let(:params) { { user: attributes_for(:user) } }

      it 'リクエストが成功する' do
        subject
        expect(response).to have_http_status(302)
      end

      it 'ユーザーが保存される' do
        expect { subject }.to change { User.count }.by(1)
      end

      it '詳細ページにリダイレクトされる' do
        subject
        expect(response).to redirect_to User.last
      end
    end

    context 'パラメータが異常なとき' do
      let(:params) { { user: attributes_for(:user, :invalid) } }

      it 'リクエストが成功する' do
        subject
        expect(response).to have_http_status(200)
      end

      it 'ユーザーが保存されない' do
        expect { subject }.not_to change(User, :count)
      end

      it '新規登録ページがレンダリングされる' do
        subject
        expect(response.body).to include '新規登録'
      end
    end
  end

  describe 'GET #edit' do
    subject { get(edit_user_path(user_id)) }
    context 'ユーザーが存在するとき' do
      let(:user) { create(:user) }
      let(:user_id) { user.id }

      it 'リクエストが成功する' do
        subject
        expect(response).to have_http_status(:ok)
      end

      it 'nameが表示されている' do
        subject
        expect(response.body).to include user.name
      end

      it 'ageが表示されている' do
        subject
        expect(response.body).to include user.age.to_s
      end

      it 'emailが表示されている' do
        subject
        expect(response.body).to include user.email
      end
    end

    context ':idに対応するユーザーが存在しないとき' do
      let(:user_id) { 1 }
      it 'エラーが発生する' do
        expect { subject }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end

  describe 'PATCH #update' do
    subject { patch(user_path(user.id), params: params) }
    let(:user) { create(:user) }

    context 'パラメータが正常な場合' do
      let(:params) { { user: attributes_for(:user) } }

      it 'リクエストが成功する' do
        subject
        expect(response).to have_http_status(302)
      end

      it 'nameが更新される' do
        origin_name = user.name
        new_name = params[:user][:name]
        expect { subject }.to change { user.reload.name }.from(origin_name).to(new_name)
      end

      it 'ageが更新される' do
        origin_age = user.age
        new_age = params[:user][:age]
        expect { subject }.to change { user.reload.age }.from(origin_age).to(new_age)
      end

      it 'emailが更新される' do
        origin_email = user.email
        new_email = params[:user][:email]
        expect { subject }.to change { user.reload.email }.from(origin_email).to(new_email)
      end

      it '詳細ページにリダイレクトされる' do
        subject
        expect(response).to redirect_to User.last
      end
    end

    context 'userのパラメータが異常なとき' do
      let(:params) { { user: attributes_for(:user, :invalid) } }

      it 'リクエストが成功する' do
        subject
        expect(response).to have_http_status(200)
      end

      it 'nameが更新されない' do
        expect { subject }.not_to change(user.reload, :name)
      end

      it 'ageが更新されない' do
        expect { subject }.not_to change(user.reload, :age)
      end

      it 'emailが更新されない' do
        expect { subject }.not_to change(user.reload, :email)
      end

      it '編集ページがレンダリングされる' do
        subject
        expect(response.body).to include '編集'
      end
    end
  end

  describe 'DELETE #destroy' do
    subject { delete(user_path(user.id)) }
    let!(:user) { create(:user) }

    context 'パラメータが正常な場合' do
      it 'リクエストが成功する' do
        subject
        expect(response).to have_http_status(302)
      end

      it 'ユーザーが削除される' do
        expect { subject }.to change(User, :count).by(-1)
      end

      it 'ユーザー一覧にリダイレクトされる' do
        subject
        expect(response).to redirect_to(users_path)
      end
    end
  end
end
