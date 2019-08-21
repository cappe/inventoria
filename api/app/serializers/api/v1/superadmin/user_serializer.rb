class Api::V1::Superadmin::UserSerializer < Api::V1::UserForAuditSerializer
  attribute :receive_orders, if: :superadmin?
end
