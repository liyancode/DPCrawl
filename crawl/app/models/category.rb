class Category

  # table 'category_level_1'
  # @param category_level_0_id int
  # @param category_id varchar
  # @return result code '200'/'302'/'500'
  def Category.insert_into_category_level_1(category_level_0_id,category_id,cn_name)
    begin
      DB.fetch(
          "insert into category_level_1(category_level_0_id,category_id,cn_name) values (#{category_level_0_id},'#{category_id}','#{cn_name}');"
      ).insert
      return '200'
    rescue Exception=>e
      p e
      return '500'
    end
  end

  def insert_into_city_category_level_1_relation(city_id,category_level_1_id)

  end
end