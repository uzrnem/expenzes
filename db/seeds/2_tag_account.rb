require "#{Rails.root}/helper/my_helper.rb"

csv = getCsvData('tag.csv')
csv.each do |row|
  data = row.to_hash.with_indifferent_access
  model = TransactionType.find_by(slug: data['transaction_type'])
	Tag.find_or_create_by!(name: data['name'], slug: data['slug'], transaction_type: model)
end
puts "Tag are Added!"


csv = getCsvData('account.csv')
csv.each do |row|
  data = row.to_hash.with_indifferent_access
  model = AccountType.find_by(slug: data['type'])
  Account.create_with(amount: data['amount'], account_type: model, is_frequent: data['is_frequent'])
  .find_or_create_by!(name: data['name'], slug: data['slug'])
end
puts "Accounts are Added!"
