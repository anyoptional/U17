//
//  ComicStaticDetailResp.swift
//
//  This file is auto generated by fit.
//  Github: https://github.com/AnyOptional/fit
//
//  Copyright © 2018-present Archer. All rights reserved.
//

import YYKit

@objcMembers
class ComicStaticDetailResp: NSObject, YYModel {

	var code: Int = 0
	var data: DataBean?

	@objcMembers
	class DataBean: NSObject, YYModel {
		var stateCode: Int = 0
		var message: String?
		var returnData: ReturnDataBean?

		@objcMembers
		class ReturnDataBean: NSObject, YYModel {
			var otherWorks: [OtherWorksBean]?

			@objcMembers
			class OtherWorksBean: NSObject, YYModel {
				var name: String?
				var passChapterNum: String?
				var coverUrl: String?
				var comicId: String?
			}

			var comic: ComicBean?

			@objcMembers
			class ComicBean: NSObject, YYModel {
				var tagList: [String]?
				var accredit: Int = 0
				var last_update_time: Int = 0
				var author: AuthorBean?

				@objcMembers
				class AuthorBean: NSObject, YYModel {
					var name: String?
					var avatar: String?
					var id: String?
				}

				var ori: String?
				var week_more: String?
				var theme_ids: [String]?
				var wideCover: String?
				var cate_id: String?
				var descriptor: String?
				var short_description: String?
				var name: String?
				var series_status: Int = 0
				var last_update_week: String?
				var is_vip: Int = 0
				var cover: String?
				var comic_id: String?
				var thread_id: String?
				var status: Int = 0
				var wideColor: String?
				var classifyTags: [ClassifyTagsBean]?

				@objcMembers
				class ClassifyTagsBean: NSObject, YYModel {
					var name: String?
					var argVal: Int = 0
					var argName: String?
				}

				var type: String?

                static func modelCustomPropertyMapper() -> [String : Any]? {
                    return ["descriptor" : "description"]
                }
                
				static func modelContainerPropertyGenericClass() -> [String : Any]? {
    				return ["classifyTags" : ClassifyTagsBean.self]
				}
			}

			var commentList: [CommentListBean]?

			@objcMembers
			class CommentListBean: NSObject, YYModel {
				var comment_from: String?
				var sex: String?
				var is_up: Int = 0
				var create_time: String?
				var face_type: String?
				var group_author: String?
				var likeState: Int = 0
				var cate: String?
				var exp: String?
				var comic_author: Int = 0
				var content_filter: String?
				var content: String?
				var ip: String?
				var id: String?
				var gift_img: String?
				var floor: String?
				var group_admin: String?
				var level: LevelBean?

				@objcMembers
				class LevelBean: NSObject, YYModel {
					var wage: Int = 0
					var ticket: Int = 0
					var max: Int = 0
					var album_size: Int = 0
					var min_exp: Int = 0
					var level: Int = 0
					var exp_speed: Int = 0
					var favorite_num: Int = 0
				}

				var title: String?
				var group_user: String?
				var is_delete: String?
				var face: String?
				var praise_total: String?
				var is_lock: String?
				var user_id: Int = 0
				var likeCount: Int = 0
				var online_time: String?
				var ticketNum: Int = 0
				var total_reply: String?
				var is_choice: Int = 0
				var create_time_str: String?
				var gift_num: Int = 0
				var vip_exp: String?
				var comment_id: String?
				var nickname: String?
			}

			var chapter_list: [Chapter_listBean]?

			@objcMembers
			class Chapter_listBean: NSObject, YYModel {
				var chapter_id: String?
				var countImHightArr: Int = 0
				var smallPlaceCover: String?
				var price: String?
				var image_total: String?
				var release_time: String?
				var zip_high_webp: String?
				var has_locked_image: Bool = false
				var vip_images: String?
				var is_new: Int = 0
				var pass_time: Int = 0
				var publish_time: Int = 0
				var name: String?
				var imHightArr: [ImHightArrBean]?

				@objcMembers
				class ImHightArrBean: NSObject, YYModel {
					var width: String?
					var height: String?
				}

				var crop_zip_size: String?
				var type: Int = 0
				var size: String?

				static func modelContainerPropertyGenericClass() -> [String : Any]? {
    				return ["imHightArr" : ImHightArrBean.self]
				}
			}


			static func modelContainerPropertyGenericClass() -> [String : Any]? {
    			return ["commentList" : CommentListBean.self,
						"chapter_list" : Chapter_listBean.self,
						"otherWorks" : OtherWorksBean.self]
			}
		}

	}

}

