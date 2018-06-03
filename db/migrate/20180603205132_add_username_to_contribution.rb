class AddUsernameToContribution < ActiveRecord::Migration[5.1]
  def change
    add_column :contributions, :username, :string
  end
end
