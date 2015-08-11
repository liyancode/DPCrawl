class CategoryLevel1<Sequel::Model(:category_level_1)
  def CategoryLevel1.insert(category_level_0_id,category_id,cn_name)
    begin
      cate=CategoryLevel1.new do |c|
        c.category_level_0_id=category_level_0_id
        c.category_id=category_id
        c.cn_name=cn_name
      end
      return cate.save.id
    rescue Exception=>e
      # p "CategoryLevel1.insert exception:#{e}"
      return -1
    end
  end

  def CategoryLevel1.get_category_level_1_id_list_by_category_level_0_id(category_level_0_id)
    begin
      id_list=[]
      CategoryLevel1.select(:category_id).where(:category_level_0_id=>category_level_0_id).each{|r|
        id_list<<r[:category_id]
      }
      return id_list
    rescue Exception=>e
      p "CategoryLevel1.get_category_level_1_id_list_by_category_level_0_id exception:#{e}"
      return []
    end
  end
end