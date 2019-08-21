class Api::V1::Admin::UserSerializer < Api::V1::UserForAuditSerializer
  attribute :receive_orders, if: :superadmin?
end
