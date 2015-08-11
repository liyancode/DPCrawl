
class ShopBrief<Sequel::Model(:shop_brief)
  def ShopBrief.insert(city_id,category_level_1_id,region_id,shop_id,cn_name,address,comments_num,comments_score,mean_price,taste_score,environment_score,service_score)
    begin
      shop=ShopBrief.new do |sh|
        sh.city_id=city_id
        sh.category_level_1_id=category_level_1_id
        sh.region_id=region_id
        sh.shop_id=shop_id
        sh.cn_name=cn_name
        sh.address=address
        sh.comments_num=comments_num
        sh.comments_score=comments_score
        sh.mean_price=mean_price
        sh.taste_score=taste_score
        sh.environment_score=environment_score
        sh.service_score=service_score
      end
      return shop.save.id
    rescue Exception=>e
      # p "CategoryLevel1.insert exception:#{e}"
      return -1
    end
  end
  def ShopBrief.insert_by_list(city_id,category_level_1_id,region_id,shop_brief_list)
    begin
      if shop_brief_list.size==0
        return
      end
      value_str=""
      shop_brief_list.each{|sb|
        value_str=value_str+"(#{city_id},'#{category_level_1_id}','#{region_id}','#{sb["shop_id"]}','#{sb["cn_name"]}','#{sb["address"]}','#{sb["comments_num"]}','#{sb["comments_score"]}','#{sb["mean_price"]}','#{sb["taste_score"]}','#{sb["env_score"]}','#{sb["sev_score"]}'),"
      }
        insert_sql="insert into shop_brief(city_id,category_level_1_id,region_id,shop_id,cn_name,address,comments_num,comments_score,mean_price,taste_score,environment_score,service_score) values #{value_str[0,value_str.size-1]};"
        DB.fetch(insert_sql).insert

    rescue Exception=>e
      # p "----ShopBrief.insert_by_list ERROR!"
      # p "ShopBrief.insert_by_list exception:#{e}"
      shop_brief_list.each{|sb|
        begin
          ShopBrief.insert(city_id,category_level_1_id,region_id,sb["shop_id"],sb["cn_name"],sb["address"],sb["comments_num"],sb["comments_score"],sb["mean_price"],sb["taste_score"],sb["env_score"],sb["sev_score"])
        rescue Exception=>e
          # p "--------ShopBrief.insert ERROR!"
        end
      }
    end
  end
end