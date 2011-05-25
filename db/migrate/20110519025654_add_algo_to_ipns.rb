class AddAlgoToIpns < ActiveRecord::Migration
  def self.up
    add_column :ipns, :algo, :string
  end

  def self.down
    remove_column :ipns, :algo
  end
end
