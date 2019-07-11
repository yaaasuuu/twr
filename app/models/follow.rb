class Follow < ApplicationRecord
    validates :user_id, {presence: true}
    validates :at_user_id, {presence: true}
end
