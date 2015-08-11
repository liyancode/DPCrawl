# pseudocode
all_city_list=[]

all_category_level_0_list=[]

http_client=HTTPClient.new

all_city_list.each{ |city|

  all_category_level_0_list.each{|category_level_0|

    city_category_0_page=http_client.get(

        "http://www.dianping.com/search/category/#{city.city_id}/#{category_level_0.category_id}/"

    ).content
    # city_category_0_page contains 'category_level_1_list' and 'region_level_1_list'
    category_level_1_list=get_category_level_1_list_by_level_0_page(city_category_0_page)
    # region_level_1_list=get_region_level_1_list_by_level_0_page(city_category_0_page) one city one time

    insert_category_level_1_list_to_db(city.city_id,category_level_0.category_id,category_level_1_list)

    category_level_1_sub_list=[]
    category_level_1_list.each{|category_level_1|
      category_level_1_page=http_client.get(
          "http://www.dianping.com/search/category/#{city.city_id}/#{category_level_0.category_id}/#{category_level_1.category_id}/"
      ).content
      category_level_1_sub_list.concat(get_category_level_1_sub_list_by_level_1_page(category_level_1_page))
      insert_category_level_1_sub_list_to_db(city.city_id,category_level_0.category_id,category_level_1.category_id,category_level_1_sub_list)
    }
  }
}