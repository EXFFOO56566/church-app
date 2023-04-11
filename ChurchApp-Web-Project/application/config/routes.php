<?php
defined('BASEPATH') OR exit('No direct script access allowed');

/*
| -------------------------------------------------------------------------
| URI ROUTING
| -------------------------------------------------------------------------
| This file lets you re-map URI requests to specific controller functions.
|
| Typically there is a one-to-one relationship between a URL string
| and its corresponding controller class/method. The segments in a
| URL normally follow this pattern:
|
|	example.com/class/method/id/
|
| In some instances, however, you may want to remap this relationship
| so that a different class/function is called than the one
| corresponding to the URL.
|
| Please see the user guide for complete details:
|
|	https://codeigniter.com/user_guide/general/routing.html
|
| -------------------------------------------------------------------------
| RESERVED ROUTES
| -------------------------------------------------------------------------
|
| There are three reserved routes:
|
|	$route['default_controller'] = 'welcome';
|
| This route indicates which controller class should be loaded if the
| URI contains no data. In the above example, the "welcome" class
| would be loaded.
|
|	$route['404_override'] = 'errors/page_missing';
|
| This route will tell the Router which controller/method to use if those
| provided in the URL cannot be matched to a valid route.
|
|	$route['translate_uri_dashes'] = FALSE;
|
| This is not exactly a route, but allows you to automatically route
| controller and method names that contain dashes. '-' isn't a valid
| class or method name character, so it requires translation.
| When you set this option to TRUE, it will replace ALL dashes in the
| controller and method URI segments.
|
| Examples:	my-controller/index	-> my_controller/index
|		my-controller/my-method	-> my_controller/my_method
*/
$config['index_page'] = "";
$config['uri_protocol'] = "REQUEST_URI";
$route['default_controller'] = 'login';
$route['authorize'] = "authorize/get_secret_key";
$route['fetch_categories'] = "api/categories";
$route['discover'] = "api/discover";
$route['search'] = "api/search";
$route['fetch_media'] = "api/fetch_media";
$route['fetch_hymns'] = "api/fetch_hymns";
$route['fetch_inbox'] = "api/fetch_inbox";
$route['devotionals'] = "api/devotionals";
$route['fetch_events'] = "api/fetch_events";
$route['fetch_radios'] = "api/fetch_radios";
$route['saveDonation'] = 'api/saveDonation';
$route['download_articles'] = "api/download_articles";
$route['fetch_category_ebooks'] = "api/fetch_category_ebooks";
$route['fetch_category_articles'] = "api/fetch_category_articles";
$route['fetch_livestreams'] = "api/fetch_livestreams";
$route['getTrendingMedia'] = "api/getTrendingMedia";
$route['update_media_total_views'] = "api/update_media_total_views";
$route['likeunlikemedia'] = "api/likeunlikemedia";
$route['getmediatotallikesandcommentsviews'] = "api/getmediatotallikesandcommentsviews";
$route['fetch_categories_media'] = "api/fetch_categories_media";
$route['download'] = "api/download";
$route['storefcmtoken'] = "api/storeFcmToken";
$route['updatefcmtoken'] = "api/updateFcmToken";
$route['update_ebooks_articles_views'] = "api/update_ebooks_articles_views";
$route['get_article_content'] = "api/get_article_content";
$route['get_bible'] = "bible/get_bible";


//reactions and comments
$route['makecomment'] = "comments/makecomment";
$route['editcomment'] = "comments/editcomment";
$route['deletecomment'] = "comments/deletecomment";
$route['loadcomments'] = "comments/loadcomments";
$route['reportcomment'] = "comments/reportcomment";
$route['replycomment'] = "replies/replycomment";
$route['editreply'] = "replies/editreply";
$route['deletereply'] = "replies/deletereply";
$route['loadreplies'] = "replies/loadreplies";
$route['reportedcomments'] = 'comments/reportedcomments';
$route['deleteReport/(:num)'] = 'comments/deleteReport/$1';
$route['usercomments'] = 'comments/usercomments';
$route['getCommentsAjax'] = 'comments/getCommentsAjax';
$route['fetchandroidusers'] = 'account/fetchandroidusers';
$route['publishComment/(:num)'] = 'comments/publishComment/$1';
$route['unPublishComment/(:num)'] = 'comments/unPublishComment/$1';
$route['thrashUserComment/(:num)'] = 'comments/thrashUserComment/$1';

//android users routes
//admin and android users
$route['loginUser'] = 'account/loginUser';
$route['registerUser'] = 'account/registerUser';
$route['resetPassword'] = 'account/resetPassword';
$route['resendVerificationMail'] = 'account/resendVerificationMail';
$route['verifyEmailLink/(:any)/(:any)'] = 'account/verifyEmailLink/$1/$2';
$route['resetLink/(:any)/(:any)'] = 'account/resetLink/$1/$2';
$route['changeUserPassword'] = 'account/changeUserPassword';
$route['fetchandroidusers'] = 'account/fetchandroidusers';
$route['authenticate'] = 'login/authenticate';
$route['androidUsers'] = 'account/users';
$route['getUsersAjax'] = 'account/getUsersAjax';
$route['deleteUser/(:num)'] = 'account/deleteUser/$1';
$route['blockUser/(:num)'] = 'account/blockUser/$1';
$route['unBlockUser/(:num)'] = 'account/unBlockUser/$1';

$route['adminListing'] = 'user';
$route['newAdmin'] = 'user/newAdmin';
$route['savenewadmin'] = 'user/savenewadmin';
$route['editAdmin/(:num)'] = 'user/editAdmin/$1';
$route['editadmindata'] = 'user/editadmindata';
$route['deleteAdmin/(:num)'] = 'user/deleteAdmin/$1';

//ebooks routes
$route['ebooksListing'] = 'ebooks';
$route['fetchEbooks'] = 'ebooks/fetch';
$route['newEbook'] = 'ebooks/newEbook';
$route['saveNewEbook'] = 'ebooks/saveNewEbook';
$route['editEbook/(:num)'] = 'ebooks/editEbook/$1';
$route['editEbookData'] = 'ebooks/editEbookData';
$route['deleteEbook/(:num)'] = 'ebooks/deleteEbook/$1';

//ebooks routes
$route['articlesListing'] = 'articles';
$route['fetchArticles'] = 'articles/fetch';
$route['newArticle'] = 'articles/newArticle';
$route['saveNewArticle'] = 'articles/saveNewArticle';
$route['editArticle/(:num)'] = 'articles/editArticle/$1';
$route['editArticleData'] = 'articles/editArticleData';
$route['deleteArticle/(:num)'] = 'articles/deleteArticle/$1';

//audio routes
$route['audioListing'] = 'audio';
$route['fetchAudios'] = 'audio/fetch';
$route['newAudio'] = 'audio/newAudio';
$route['saveNewAudio'] = 'audio/saveNewAudio';
$route['editAudio/(:num)'] = 'audio/editAudio/$1';
$route['editAudioData'] = 'audio/editAudioData';
$route['deleteAudio/(:num)'] = 'audio/deleteAudio/$1';

//music routes
$route['musicListing'] = 'music';
$route['fetchMusic'] = 'music/fetch';
$route['newMusic'] = 'music/newMusic';
$route['saveNewMusic'] = 'music/saveNewMusic';
$route['editMusic/(:num)'] = 'music/editMusic/$1';
$route['editMusicData'] = 'music/editMusicData';
$route['deleteMusic/(:num)'] = 'music/deleteMusic/$1';

//video routes
$route['videoListing'] = 'video';
$route['fetchVideos'] = 'video/fetch';
$route['newVideo'] = 'video/newVideo';
$route['saveNewVideo'] = 'video/saveNewVideo';
$route['editVideo/(:num)'] = 'video/editVideo/$1';
$route['editVideoData'] = 'video/editVideoData';
$route['deleteVideo/(:num)'] = 'video/deleteVideo/$1';

//settings
$route['settings'] = 'settings';
$route['updateSettings'] = 'settings/updateSettings';
$route['searchIndex'] = 'settings/searchIndex';
$route['createElasticIndex'] = 'settings/createElasticIndex';

//settings
$route['notifications'] = 'fcm';
$route['sendNotification'] = 'fcm/sendNotification';

//interest routes
$route['categoriesListing'] = 'categories';
$route['newCategory'] = 'categories/newCategory';
$route['savenewcategory'] = 'categories/savenewcategory';
$route['editCategory/(:num)'] = 'categories/editCategory/$1';
$route['editCategoryData'] = 'categories/editCategoryData';
$route['deleteCategory/(:num)'] = 'categories/deleteCategory/$1';
$route['loadcategories'] = 'categories/loadcategories';

//sub categories routes
$route['subcategoryListing'] = 'categories/subcategoryListing';
$route['newSubCategory'] = 'categories/newSubCategory';
$route['savenewsubcategory'] = 'categories/savenewsubcategory';
$route['editSubCategory/(:num)'] = 'categories/editSubCategory/$1';
$route['editSubCategoryData'] = 'categories/editSubCategoryData';
$route['deleteSubCategory/(:num)'] = 'categories/deleteSubCategory/$1';
$route['loadsubcategories'] = 'categories/loadsubcategories';

//livestreams routes
$route['updateLiveStreams'] = "livestreams/updateLiveStreams";
$route['fetch_live_streams'] = "api/fetch_live_streams";
$route['update_live_streams'] = "api/update_live_streams";

//livestreams routes
$route['updateRadio'] = "radio/updateRadio";

//events routes
$route['eventsListing'] = 'events';
$route['newEvent'] = 'events/newEvent';
$route['savenewevent'] = 'events/savenewevent';
$route['editEvent/(:num)'] = 'events/editEvent/$1';
$route['editEventData'] = 'events/editEventData';
$route['deleteEvent/(:num)'] = 'events/deleteEvent/$1';


//inbox routes
$route['inboxListing'] = 'inbox';
$route['newInbox'] = 'inbox/newInbox';
$route['savenewinbox'] = 'inbox/savenewinbox';
$route['editInbox/(:num)'] = 'inbox/editInbox/$1';
$route['editInboxData'] = 'inbox/editInboxData';
$route['deleteInbox/(:num)'] = 'inbox/deleteInbox/$1';


//devotionals routes
$route['getDevotionals'] = 'devotionals/getDevotionals';
$route['devotionalsListing'] = 'devotionals/devotionalsListing';
$route['newDevotional'] = 'devotionals/newDevotional';
$route['saveNewDevotional'] = 'devotionals/saveNewDevotional';
$route['editDevotional/(:num)'] = 'devotionals/editDevotional/$1';
$route['editDevotionalData'] = 'devotionals/editDevotionalData';
$route['deleteDevotional/(:num)'] = 'devotionals/deleteDevotional/$1';

//worship/hymns routes
$route['getHymns'] = 'hymns/getHymns';
$route['hymnsListing'] = 'hymns/hymnsListing';
$route['newHymn'] = 'hymns/newHymn';
$route['saveNewHymn'] = 'hymns/saveNewHymn';
$route['editHymn/(:num)'] = 'hymns/editHymn/$1';
$route['editHymnData'] = 'hymns/editHymnData';
$route['deleteHymn/(:num)'] = 'hymns/deleteHymn/$1';

//notification routes
$route['getNotifications'] = 'devotionals/getNotifications';
$route['notificationsListing'] = 'devotionals/notificationsListing';
$route['newNotification'] = 'devotionals/newNotification';
$route['saveNewNotification'] = 'devotionals/saveNewNotification';
$route['editNotification/(:num)'] = 'devotionals/editNotification/$1';
$route['editNotificationData'] = 'devotionals/editNotificationData';
$route['deleteNotification/(:num)'] = 'devotionals/deleteNotification/$1';

$route['coinsListing'] = 'coins';
$route['coinspurchaseslisting'] = 'coins/coinspurchaseslisting';
$route['coinPurchases'] = 'coins/coinPurchases';
$route['newCoins'] = 'coins/newCoins';
$route['savenewcoins'] = 'coins/savenewcoins';
$route['editCoins/(:num)'] = 'coins/editCoins/$1';
$route['editCoinsData'] = 'coins/editCoinsData';
$route['deleteCoins/(:num)'] = 'coins/deleteCoins/$1';
$route['loadcoins'] = 'api/loadcoins';
$route['record_payment'] = 'api/record_payment';
$route['get_user_coins'] = 'api/get_user_coins';
$route['fetch_purchases'] = 'api/fetch_purchases';
$route['purchase_media'] = 'api/purchase_media';
$route['fetch_user_purchases'] = 'api/fetch_user_purchases';

$route['donationslisting'] = 'donations/donationslisting';

//coupons routes
$route['newCoupon'] = 'coupons/newCoupon';
$route['generatecoupons'] = 'coupons/generatecoupon';
$route['printcoupons'] = 'coupons/printcoupons';
$route['deleteGroupCoupons'] = 'coupons/deleteGroupCoupons';
$route['deleteCoupon/(:num)'] = 'coupons/deleteCoupon/$1';
$route['subscribeCoupon'] = 'coupons/subscribeCoupon';

//social platform ROUTES
$route['updateUserSocialFcmToken'] = "socials/updateUserSocialFcmToken";
$route['updateProfile'] = "socials/updateUserProfile";
$route['get_users_to_follow'] = "socials/get_users_to_follow";
$route['follow_unfollow_user'] = "socials/follow_unfollow_user";
$route['make_post'] = "socials/make_post";
$route['make_post_flutter'] = "socials/make_post_flutter";
$route['editpost'] = "socials/editpost";
$route['deletepost'] = "socials/deletepost";
$route['fetch_posts_flutter'] = "socials/fetch_posts_flutter";
$route['fetch_posts'] = "socials/fetch_posts";
$route['likeunlikepost'] = "socials/likeunlikepost";
$route['pinunpinpost'] = "socials/pinunpinpost";
$route['userBioInfo'] = "socials/userBioInfo";
$route['userBioInfoFlutter'] = "socials/userBioInfoFlutter";
$route['userFollowPostCount'] = "socials/userFollowPostCount";
$route['fetchUserPosts'] = "socials/fetchUserPosts";
$route['fetchUserPostsflutter'] = "socials/fetchUserPostsflutter";
$route['users_follow_people'] = "socials/users_follow_people";
$route['update_user_settings'] = "socials/update_user_settings";
$route['fetch_user_settings'] = "socials/fetch_user_settings";
$route['fetchUserPins'] = "socials/fetchUserPins";
$route['fetchUserPinsFlutter'] = "socials/fetchUserPinsFlutter";
$route['post_likes_people'] = "socials/post_likes_people";
$route['userNotifications'] = "socials/userNotifications";
$route['deleteNotification'] = "socials/deleteNotification";
$route['setSeenNotifications'] = "socials/setSeenNotifications";
$route['getUnSeenNotifications'] = "socials/getUnSeenNotifications";


//reactions and comments
$route['makepostcomment'] = "postcomments/makecomment";
$route['editpostcomment'] = "postcomments/editcomment";
$route['deletepostcomment'] = "postcomments/deletecomment";
$route['loadpostcomments'] = "postcomments/loadcomments";
$route['reportpostcomment'] = "postcomments/reportcomment";
$route['replypostcomment'] = "postreplies/replycomment";
$route['editpostreply'] = "postreplies/editreply";
$route['deletepostreply'] = "postreplies/deletereply";
$route['loadpostreplies'] = "postreplies/loadreplies";

$route['reportedpostcomments'] = 'postcomments/reportedcomments';
$route['deletePostReport/(:num)'] = 'postcomments/deleteReport/$1';
$route['userpostcomments'] = 'postcomments/usercomments';
$route['getPostCommentsAjax'] = 'postcomments/getCommentsAjax';
$route['publishPostComment/(:num)'] = 'postcomments/publishComment/$1';
$route['unPublishPostComment/(:num)'] = 'postcomments/unPublishComment/$1';
$route['thrashUserPostComment/(:num)'] = 'postcomments/thrashUserComment/$1';

$route['branchesListing'] = 'branches';
$route['newBranch'] = 'branches/newBranch';
$route['savenewbranch'] = 'branches/savenewbranch';
$route['editBranch/(:num)'] = 'branches/editBranch/$1';
$route['editBranchData'] = 'branches/editBranchData';
$route['deleteBranch/(:num)'] = 'branches/deleteBranch/$1';
$route['loadbranches'] = 'branches/loadbranches';
$route['church_branches'] = 'branches/church_branches';

$route['donate'] = 'donations/donate';
$route['thank_you'] = 'donations/thank_you';
$route['update_donations_api'] = 'donations/update_donations_api';
$route['updatedonationSettings'] = 'donations/updatedonationSettings';


$route['biblesListing'] = 'bible';
$route['newBible'] = 'bible/newBible';
$route['savenewbible'] = 'bible/savenewbible';
$route['deleteBible/(:num)'] = 'bible/deleteBible/$1';
$route['editBible/(:num)'] = 'bible/editBible/$1';
$route['editBibleData'] = 'bible/editBibleData';
$route['getBibleVersions'] = 'bible/getBibleVersions';


$route['fetch_user_chats'] = 'chat/fetch_user_chats';
$route['load_more_chats'] = 'chat/load_more_chats';
$route['fetch_user_partner_chat'] = 'chat/fetch_user_partner_chat';
$route['save_user_conversation'] = 'chat/save_user_conversation';
$route['on_seen_conversation'] = 'chat/on_seen_conversation';
$route['on_user_typing'] = 'chat/on_user_typing';
$route['update_user_online_status'] = 'chat/update_user_online_status';
$route['delete_selected_chat_messages'] = 'chat/delete_selected_chat_messages';
$route['clear_user_conversation'] = 'chat/clear_user_conversation';
$route['blockUnblockUser'] = 'chat/blockUnblockUser';
$route['checkfornewmessages'] = 'chat/checkfornewmessages';



$route['logout'] = 'user/logout';
//$route['(:any)'] = 'view/$1';
$route['404_override'] = 'error_page';
$route['translate_uri_dashes'] = FALSE;
