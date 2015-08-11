# id serial Primary key NOT NULL,
# city_id int, cn_name varchar, pinyin varchar NOT NULL, other varchar

# city.rb
class City<Sequel::Model(:city)
  # @param [[city_id,"cn_name","pinyin","other"],[],...]
  def City.insert(city_list_arr)
    if city_list_arr.size>0
      values_str=""
      city_list_arr.each{ |city|
        values_str=values_str+",(#{city[0]},'#{city[1]}','#{city[2]}','#{city[3]}')"
      }

      insert_sql="insert into city (city_id,cn_name,pinyin,other) values #{values_str[1,values_str.size-1]}"

      begin
        DB.fetch(insert_sql).insert
        return 200
      rescue Exception=>e
        p e
        return 500
      end
    end
  end

  def City.select_all
    result=[]
    begin
      DB.fetch("select * from city") do |r|
        result<<r
      end
      return result
    rescue Exception=>e
      p e
      return []
    end
  end
  # @param [[city_id,"cn_name","pinyin","other"],[],...]
  def City.update_cityid_by_id(id,city_id)
    begin
      DB.fetch("update city set city_id=#{city_id} where id=#{id}").update
    rescue Exception=>e
      p e
    end
  end
end