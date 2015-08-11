# DPPageCrawl class
class DPPageCrawl

  def DPPageCrawl.cate_id_and_cn_name(a_href)
    a_href
    cate_id=a_href[a_href.index('/g')+1,a_href.index('<span>')-a_href.index('/g')-4]
    cn_name=a_href[a_href.index('<span>')+6,a_href.index('</span>')-a_href.index('<span>')-6]
    return [cate_id,cn_name]
  end

  # @param class=String
  def DPPageCrawl.get_category_level_1_list_by_level_0_page(city_category_level_0_page_html_content)
    begin
      index_l=city_category_level_0_page_html_content.index("navigation")
      index_r=city_category_level_0_page_html_content.index("\"content-wrap\"")
      nav_content=city_category_level_0_page_html_content[index_l,index_r-index_l]
      cate_level_1_content_index_l=nav_content.index('nc-items')+27
      cate_level_1_content_index_r=nav_content[cate_level_1_content_index_l,nav_content.size-cate_level_1_content_index_l-1].index("</div>")

      cate_level_1_content=nav_content[cate_level_1_content_index_l,cate_level_1_content_index_r-12]
      list=[]
      cate_level_1_content.split("\n").each{|a_g|
        id_cn=cate_id_and_cn_name(a_g)
        list<<{:category_id=>id_cn[0],:cn_name=>id_cn[1]}
      }
      return list
    rescue Exception=>e
      p "exception when DPPageCrawl.get_category_level_1_list_by_level_0_page"
      return []
    end
  end

  # @param class=String
  def DPPageCrawl.get_category_level_1_sub_list_by_level_1_page(city_category_level_1_page_html_content)
    begin
      index_l=city_category_level_1_page_html_content.index("navigation")
      index_r=city_category_level_1_page_html_content.index("\"content-wrap\"")
      nav_content=city_category_level_1_page_html_content[index_l,index_r-index_l]
      cate_level_1_content_index_l=nav_content.index('nc-sub')+27
      cate_level_1_content_index_r=nav_content[cate_level_1_content_index_l,nav_content.size-cate_level_1_content_index_l-1].index("</div>")

      cate_level_1_content=nav_content[cate_level_1_content_index_l,cate_level_1_content_index_r-12]
      list=[]
      cate_level_1_content.split("\n").each{|a_g|
        id_cn=cate_id_and_cn_name(a_g)
        list<<{:category_id=>id_cn[0],:cn_name=>id_cn[1]}
      }
      return list
    rescue Exception=>e
      p "exception when DPPageCrawl.get_category_level_1_sub_list_by_level_1_page"
      return []
    end
  end

  # =============
  def DPPageCrawl.region_id_and_cn_name(a_href)
    if a_href.index("/r")==nil
      id=a_href[a_href.index("/10/c")+4,a_href.index("#nav")-a_href.index("/10/c")-4]
    else
      id=a_href[a_href.index("/r")+1,a_href.index("#nav")-a_href.index("/r")-1]
    end
    cn_name=a_href[a_href.index("<span>")+6,a_href.index("</span>")-a_href.index("<span>")-6]
    return [id,cn_name]
  end

  # @param class=String
  def DPPageCrawl.get_region_list_by_level_0_page(city_category_level_0_page_html_content)
    begin
      index_l=city_category_level_0_page_html_content.index("navigation")
      index_r=city_category_level_0_page_html_content.index("\"content-wrap\"")
      nav_content=city_category_level_0_page_html_content[index_l,index_r-index_l]

      list=[]

      bussi_index_l=nav_content.index("bussi-nav")
      bussi_content_1=nav_content[bussi_index_l,nav_content.size-bussi_index_l-1]
      bussi_content_2=bussi_content_1[bussi_content_1.index("<a"),bussi_content_1.index("</div>")-16-bussi_content_1.index("<a")]

      bussi_content_2.split("\n").each{|bs|
        id_and_cn_name=region_id_and_cn_name(bs)
        list<<{:region_type=>"bussi",:region_id=>id_and_cn_name[0],:region_cn_name=>id_and_cn_name[1]}
      }

      region_index_l=nav_content.index("region-nav")
      region_content_1=nav_content[region_index_l,nav_content.size-region_index_l-1]
      region_content_2=region_content_1[region_content_1.index("<a"),region_content_1.index("</div>")-16-region_content_1.index("<a")]
      region_content_2.split("\n").each{|rg|
        id_and_cn_name=region_id_and_cn_name(rg)
        list<<{:region_type=>"region",:region_id=>id_and_cn_name[0],:region_cn_name=>id_and_cn_name[1]}
      }
      return list
    rescue Exception=>e
      p "exception when DPPageCrawl.get_region_list_by_level_0_page"
      return []
    end
  end

  def DPPageCrawl.get_shop_brief_list_by_category_level_1_region_page(page_content)
    begin
      shop_brief_list=[]
      indx_l=page_content.index("id=\"shop-all-list\"")
      list_ul_content=page_content[page_content.index("<ul>",indx_l),page_content.index("</ul>",indx_l)-page_content.index("<ul>",indx_l)+5]
      li_list_str=list_ul_content[list_ul_content.index("<li")..-6]+"\n"
      li_list=li_list_str.split("</div>\n</li>\n\n\n\n\n\n")
      li_list.each{|shop_li|
        begin
          shop_brief={}
          shop_id_index_l=shop_li.index("/shop")+6
          shop_brief["shop_id"]=shop_li[shop_id_index_l,shop_li.index("\"",shop_id_index_l)-shop_id_index_l]

          shop_cn_name_index_l=shop_li.index("<img title=")+12
          shop_brief["cn_name"] =shop_li[shop_cn_name_index_l,shop_li.index("alt",shop_cn_name_index_l)-2-shop_cn_name_index_l]

          shop_addr_index_l=shop_li.index("class=\"addr\"")+13
          shop_brief["address"] =shop_li[shop_addr_index_l,shop_li.index("</span>",shop_addr_index_l)-shop_addr_index_l]

          shop_comments_score_index_l=shop_li.index("class=\"sml-rank-stars")+29
          shop_brief["comments_score"]=shop_li[shop_comments_score_index_l,shop_li.index("\"",shop_comments_score_index_l)-shop_comments_score_index_l]

          temp_index_l=shop_li.index("class=\"review-num\"")
          if temp_index_l!=nil
            shop_comments_num_index_l=shop_li.index("<b>",temp_index_l)+3
            shop_comments_num=shop_li[shop_comments_num_index_l,shop_li.index("</b>",shop_comments_num_index_l)-shop_comments_num_index_l]
          else
            shop_comments_num=0
          end
          shop_brief["comments_num"] =shop_comments_num

          rmb_index=shop_li.index("￥")
          if rmb_index!=nil
            shop_mean_price=shop_li[rmb_index+1,shop_li.index("</b>",rmb_index)-rmb_index-1]
          else
            shop_mean_price=0
          end
          shop_brief["mean_price"]=shop_mean_price

          taste_index=shop_li.index("口味")
          if taste_index!=nil
            taste_score=shop_li[taste_index+5,shop_li.index("</b>",taste_index)-taste_index-5]
          else
            taste_score=0
          end
          shop_brief["taste_score"]=taste_score

          env_index=shop_li.index("环境")
          if env_index!=nil
            env_score=shop_li[env_index+5,shop_li.index("</b>",env_index)-env_index-5]
          else
            env_score=0
          end
          shop_brief["env_score"]= env_score

          sev_index=shop_li.index("服务")
          if sev_index!=nil
            sev_score=shop_li[sev_index+5,shop_li.index("</b>",sev_index)-sev_index-5]
          else
            sev_score=0
          end
          shop_brief["sev_score"]= sev_score
          shop_brief_list<<shop_brief
        rescue Exception=>e

        end
      }
        return shop_brief_list

    rescue Exception=>e
      # p "exception when DPPageCrawl.get_region_list_by_level_0_page"
      return []
    end
  end
  #   ==========
end