# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
i = 0
locations = ["東京", "深圳", "バンコク", "デュッセルドルフ", "ダラス", "その他"]
department_name = ["所属未定", "管理課", "企画課", "営業課", "製造課", "開発課", "その他"]
product_category = ['マウス', 'キーボード', 'バッテリー']
product_status = ['開発中', '製造中', '製造中止']
product_locations = ['未定', '東京', '深圳', 'バンコク', 'デュッセルドルフ', 'ダラス']
document_category = ['その他文書', 'ビジネスプラン', 'マスタープラン', '製品仕様書', '設計書', '試作報告書', '量産試作報告書', '歩留り評価報告書', '作業手順書', '議事録']


#7.times { |i|
#  Department.create!(
#    {id: i+1, name: "#{department_name[i]}", location: locations.sample, description: Faker::Lorem.word }
#  )
#}

#7.times { |i|
#  User.create!(
#    { name: "test0#{i+1}",
#      mr_ms: ['Mr.', 'Ms.'].sample,
#      email: "test0#{i+1}@example.com",
#      password: "test0#{i+1}",
#      employee_number: "12345#{i}".to_i}
#  )
#}

#7.times { |i|
#  Product.create!(
#    {
#     category: product_category.sample,
#     description: Faker::Lorem.sentence,
#     status: product_status.sample,
#     }
#  )
#}
#Product.all.each { |product|
#  if product.status == '開発中'
#    product.update!(location: product_locations[0])
#  else
#    product.update!(location: ['深圳', 'バンコク', 'ダラス'].sample)
#  end
#}
#unless Product.where(category: 'マウス').count == 0
#  Product.where(category: 'マウス').each { |product|
#    product.update(name: "#{Faker::Lorem.word}マウス")
#  }
#end
#unless Product.where(category: 'キーボード').count == 0
#  Product.where(category: 'キーボード').each { |product|
#    product.update(name: "#{Faker::Lorem.word}キーボード")
#  }
#end
#unless Product.where(category: 'バッテリー').count == 0
#  Product.where(category: 'バッテリー').each { |product|
#    product.update(name: "#{Faker::Lorem.word}バッテリー")
#  }
#end

# documentsのseedデータ作成。Productそれぞれについて、文書を作っていく。

Product.all.each { |product|
  case product.status
#    when "製造中" then
#      for element in document_category
#        Document.create!(
#          {
#            product_id: product.id,
#            user_id: User.all.sample.id,
#            category: element,
#            authorize: true,
#            title: "#{product.name}#{element}",
#            content: "test",
#          }
#        )
#      end
    when "製造中止" then
      for element in document_category
        Document.create!(
          {
            product_id: product.id,
            user_id: User.all.sample.id,
            category: element,
            authorize: true,
            title: "#{product.name}#{element}",
            content: "test",
          }
        )
      end
  end
}
