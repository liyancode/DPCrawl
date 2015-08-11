require 'httpclient'
require 'sequel'
require 'require_all'

DB=Sequel.connect('postgres://***:***@localhost:5432/dianping')

require_relative '../app/crawl/dp_page_crawl'
require_all 'models'

#1. crawl all category_level_1 and category_level_1_sub
# 1.1取top25的城市ID
city_id_list=[5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,21]
category_level_0_id_list=[10]#[10,20,25,30,35,45,50,55,60,65,70,75,80,90]

http_client=HTTPClient.new
http_client.set_cookie_store('cookie_store.dat')

# get category
city_category_list_file = File.open("city_category.txt","a")

city_id_list.each{|city_id|
  begin
    city_category_list_file.puts("====>city_id:#{city_id}")
    p "====>city_id:#{city_id}"
    category_level_0_id_list.each{|category_level_0_id|
      begin
        city_category_list_file.puts("  ====>category_level_0_id:#{category_level_0_id}")
        p "  ====>category_level_0_id:#{category_level_0_id}"
        city_category_level_0_page_html_content=http_client.get("http://www.dianping.com/search/category/#{city_id}/#{category_level_0_id}/").content
        http_client.save_cookie_store
        category_level_1_list=DPPageCrawl.get_category_level_1_list_by_level_0_page(city_category_level_0_page_html_content)
        category_level_1_list.each{|category_level_1|
          begin
            city_category_list_file.puts("    ====>category_level_1_id:#{category_level_1[:category_id]},category_level_1_cn_name:#{category_level_1[:cn_name]}")
            p "    ====>category_level_1_id:#{category_level_1[:category_id]},category_level_1_cn_name:#{category_level_1[:cn_name]}"
            # a. save category_level_1 and city_category_level_1_relation
            CategoryLevel1.insert(category_level_0_id,category_level_1[:category_id],category_level_1[:cn_name])
            city_category_level_1_relation_id=CityCategoryLevel1Relation.insert(city_id,category_level_1[:category_id])
            if city_category_level_1_relation_id==-1
              city_category_level_1_relation_id=CityCategoryLevel1Relation.get_id(city_id,category_level_1[:category_id])
            end
            if city_category_level_1_relation_id!=-1
              # b. get category_level_1_sub
              city_category_level_1_page_html_content=http_client.get("http://www.dianping.com/search/category/#{city_id}/#{category_level_0_id}/#{category_level_1[:category_id]}/").content
              http_client.save_cookie_store
              category_level_1_sub_list=DPPageCrawl.get_category_level_1_sub_list_by_level_1_page(city_category_level_1_page_html_content)
              category_level_1_sub_list.each{|category_level_1_sub|
                begin
                  if category_level_1_sub[:cn_name]!="不限"
                    city_category_list_file.puts("      ====>category_level_1_sub_id:#{category_level_1_sub[:category_id]},category_level_1_sub_cn_name:#{category_level_1_sub[:cn_name]}")
                    p "      ====>category_level_1_sub_id:#{category_level_1_sub[:category_id]},category_level_1_sub_cn_name:#{category_level_1_sub[:cn_name]}"
                    # c. save category_level_1_sub and city_category_level_1_sub_relation
                    CategoryLevel1.insert(category_level_0_id,category_level_1_sub[:category_id],category_level_1_sub[:cn_name])
                    CityCategoryLevel1SubRelation.insert(city_category_level_1_relation_id,category_level_1_sub[:category_id])
                  end
                rescue Exception=>e
                  p "c exception:#{e}"
                end
              }
            end
          rescue Exception=>e
            p "a exception:#{e}"
          end
        }
      rescue Exception=>e
        p "1.1-2 exception:#{e}"
      end
    }
  rescue Exception=>e
    p "1.1-1 exception:#{e}"
  end
}

# get region
city_region_file = File.open("city_region.txt","a")
city_id_list.each{|city_id|
  # city loop
  begin
    city_region_file.puts("====>city_id:#{city_id}")
    p "====>city_id:#{city_id}"
    city_category_level_0_page_html_content=http_client.get("http://www.dianping.com/search/category/#{city_id}/10/").content
    http_client.save_cookie_store
    region_list=DPPageCrawl.get_region_list_by_level_0_page(city_category_level_0_page_html_content)
    region_list.each{|rg|
      # region list loop
      begin
        city_region_file.puts("  ====>region_id:#{rg[:region_id]},type:#{rg[:region_type]},cn_name:#{rg[:region_cn_name]}")
        p "  ====>region_id:#{rg[:region_id]},type:#{rg[:region_type]},cn_name:#{rg[:region_cn_name]}"
        Region.insert(city_id,rg[:region_id],rg[:region_type],rg[:region_cn_name])
      rescue Exception=>e
        p "region list loop exception:#{e}"
      end
    }
  rescue Exception=>e
    p "city loop exception:#{e}"
  end
}

# get shop brief info
categ_0_and_1_list={}
category_level_0_id_list.each{|category_level_0_id|
  categ_0_and_1_list["#{category_level_0_id}"]=CategoryLevel1.get_category_level_1_id_list_by_category_level_0_id(category_level_0_id)
}
city_id_list.each{|city_id|
  p "city_id:#{city_id}"
  region_id_list=Region.get_region_id_list_by_city_id(city_id)

  category_level_0_id_list.each{|category_level_0_id|
    category_level_1_id_list=categ_0_and_1_list["#{category_level_0_id}"]
    if category_level_1_id_list.size>0
      in_str="";
      category_level_1_id_list.each{|category_level_1_id|
        in_str=in_str+"'#{category_level_1_id}',"
      }
      in_sql="select id from city_category_level_1_relation where city_id=#{city_id} and category_level_1_id in (#{in_str[0,in_str.size-1]});"
      city_category_level_1_relation_id_list=[]
      DB.fetch(in_sql).select.each{|r|
        city_category_level_1_relation_id_list<<r[:id]
      }
      city_category_level_1_relation_id_list.sort!
      city_category_level_1_relation_id_list.each{|city_category_level_1_relation_id|
        p "  city_category_level_1_relation_id:#{city_category_level_1_relation_id}"
        category_level_1_sub_id_list=CityCategoryLevel1SubRelation.get_category_level_1_sub_id_list_by_city_category_level_1_relation_id(city_category_level_1_relation_id)
        if category_level_1_sub_id_list.size==0
          category_level_1_id=CityCategoryLevel1Relation.get_category_level_1_id_by_id(city_category_level_1_relation_id)
          if category_level_1_id!="null"
            category_level_1_sub_id_list=[category_level_1_id]
          end
        end
        p category_level_1_sub_id_list=category_level_1_sub_id_list.sort
        category_level_1_sub_id_list.each{|cate_id|
          # p "    cate 1 id:#{cate_id}"
          begin
            region_id_list.each{|region_id|
              # p "      region_id:#{region_id}"
              begin
                #   get shop list
                page_content=http_client.get("http://www.dianping.com/search/category/#{city_id}/#{category_level_0_id}/#{cate_id}#{region_id}o2").content
                http_client.save_cookie_store

                index_n=page_content.index("bread J_bread")
                bread_J_bread_div=page_content[index_n,page_content.index("</div>",index_n)-index_n]
                shop_num= bread_J_bread_div[bread_J_bread_div.index("(")+1,bread_J_bread_div.index(")")-bread_J_bread_div.index("(")-1]

                page_count=shop_num.to_i/15+1

                shop_list=DPPageCrawl.get_shop_brief_list_by_category_level_1_region_page(page_content)
                ShopBrief.insert_by_list(city_id,cate_id,region_id,shop_list)
                  page_i=1
                  while page_i<page_count
                    page_i=page_i+1
                    begin
                      page_content=http_client.get("http://www.dianping.com/search/category/#{city_id}/#{category_level_0_id}/#{cate_id}#{region_id}o2p#{page_i}").content
                      http_client.save_cookie_store
                      shop_list=DPPageCrawl.get_shop_brief_list_by_category_level_1_region_page(page_content)
                      ShopBrief.insert_by_list(city_id,cate_id,region_id,shop_list)
                        p "      shop_page #{page_i}"
                    rescue Exception=>e
                      p "        get page_#{page_i} error"
                    end
                  end
              rescue Exception=>e
                # p "      get shop list error"
              end

            }
          rescue Exception=>e
            # p "    get cate region error"
          end
        }
      }
    end
  }
}