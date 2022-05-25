class CreateArticles < ActiveRecord::Migration[7.0]
  def change
    create_table :articles do |t|
      t.string :title
      t.string :url
      t.datetime :publish_date
      t.string :image_url
      t.text :abstract
      t.text :content

      t.timestamps
    end
  end
end
