class Api::V1::UserSerializer < ApplicationSerializer
  attributes :id,
             :email,
             :access_token,
             :is_customer,
             :is_admin
end
