<?php
$url = 'http://' . $_SERVER['SERVER_NAME'] . $_SERVER['REQUEST_URI'];
?>
<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=Edge">
    <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title>Admin Dashboard</title>
    <!-- Favicon-->
    <link rel="icon" href="<?php echo asset_url('images/favicon.ico'); ?>" type="image/x-icon">

    <!--REQUIRED PLUGIN CSS-->

    <link href="<?php echo asset_url('plugins/font-awesome/css/font-awesome.min.css'); ?>" rel="stylesheet">
    <link href="<?php echo asset_url('plugins/bootstrap/css/bootstrap.css'); ?>" rel="stylesheet">
     <link href="<?php echo asset_url('plugins/sweetalert/sweetalert.css'); ?>" rel="stylesheet">
   <link href="<?php echo asset_url('plugins/alertify/css/alertify.css'); ?>" rel="stylesheet">
    <link href="<?php echo asset_url('plugins/bootstrap-select/css/bootstrap-select.css'); ?>" rel="stylesheet">
    <link href="<?php echo asset_url('plugins/bootstrap-material-datetimepicker/css/bootstrap-material-datetimepicker.css'); ?>" rel="stylesheet">
    <link href="<?php echo asset_url('plugins/bootstrap-daterange/daterangepicker.css'); ?>" rel="stylesheet">


        <!--THIS PAGE LEVEL CSS-->
        <link href="<?php echo asset_url('plugins/jquery-datatable/skin/bootstrap/css/dataTables.bootstrap.css'); ?>" rel="stylesheet">
        <link href="<?php echo asset_url('plugins/jquery-datatable/skin/bootstrap/css/responsive.bootstrap.min.css'); ?>" rel="stylesheet">
        <link href="<?php echo asset_url('plugins/jquery-datatable/skin/bootstrap/css/scroller.bootstrap.min.css'); ?>" rel="stylesheet">
        <link href="<?php echo asset_url('plugins/jquery-datatable/skin/bootstrap/css/fixedHeader.bootstrap.min.css'); ?>" rel="stylesheet">

    <!--THIS PAGE LEVEL CSS-->
    <link href="<?php echo asset_url('plugins\alertify\css\alertify.css'); ?>" rel="stylesheet">

    <link href="<?php echo asset_url('plugins/jquery-datatable/skin/bootstrap/css/scroller.bootstrap.min.css'); ?>" rel="stylesheet">
    <link href="<?php echo asset_url('plugins/jquery-datatable/skin/bootstrap/css/fixedHeader.bootstrap.min.css'); ?>" rel="stylesheet">

    <!--REQUIRED THEME CSS -->
    <link href="<?php echo asset_url('plugins/dropify/dist/css/dropify.min.css'); ?>" rel="stylesheet">


    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css?family=Roboto:400,700&subset=latin,cyrillic-ext" rel="stylesheet" type="text/css">
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet" type="text/css">

    <!-- Animation Css -->
    <link href="<?php echo asset_url('plugins/animate-css/animate.css'); ?>" rel="stylesheet" />

    <!-- Custom Css -->
    <link href="<?php echo asset_url('css/style.css'); ?>" rel="stylesheet">

    <!-- AdminBSB Themes. You can choose a theme from css/themes instead of get all themes -->
    <link href="<?php echo asset_url('css/themes/all-themes.css'); ?>" rel="stylesheet" />
    <script src="https://cdn.dashjs.org/latest/dash.all.min.js"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/video.js/7.0.0/video-js.css" rel="stylesheet">
  <script src="https://cdnjs.cloudflare.com/ajax/libs/video.js/7.0.0/video.min.js"></script>
  <script src='<?= base_url() ?>assets/tinymce/tinymce.js'></script>

    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!--[if lt IE 9]>
    <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
    <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->
<script type="text/javascript">
        var baseURL = "<?php echo base_url(); ?>";
    </script>

</head>

<body class="light layout-fixed theme-blue">
  <!-- #END# Search Bar -->
  <!-- Top Bar -->
  <nav class="navbar">
      <div class="container-fluid">
          <div class="navbar-header">
              <a href="javascript:void(0);" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar-collapse" aria-expanded="false"></a>
              <a href="javascript:void(0);" class="bars"></a>
              <a class="navbar-brand" href="<?php echo site_url(); ?>">ChurchApp - ADMIN</a>
          </div>

          <div class="collapse navbar-collapse" id="navbar-collapse">
              <ul class="nav navbar-nav navbar-right">
                  <!-- #END# Call Search -->
                  <!-- Notifications -->

                  <!-- #END# Tasks -->
                  <li class="pull-right" title="logout"><a href="<?php echo base_url(); ?>logout" class="js-right-sidebar" data-close="true"><i class="material-icons">logout</i></a></li>

                  <li class="pull-right" title="Admin Accounts"><a href="<?php echo base_url(); ?>adminListing" class="js-right-sidebar" data-close="true"><i class="material-icons">account_circle</i></a></li>
                  <li class="pull-right" title="update settings"><a href="<?php echo base_url(); ?>settings" class="js-right-sidebar" data-close="true"><i class="material-icons">settings</i></a></li>
                  <li class="pull-right" title="update livestreams"><a href="<?php echo base_url(); ?>livestreams" class="js-right-sidebar" data-close="true"><i class="material-icons">live_tv</i></a></li>
                  <li class="pull-right" title="update radio"><a href="<?php echo base_url(); ?>radio" class="js-right-sidebar" data-close="true"><i class="material-icons">radio</i></a></li>
                  <li class="pull-right" title="Coupons"><a href="<?php echo base_url(); ?>coupons" class="js-right-sidebar" data-close="true"><i class="material-icons">money</i></a></li>
                  <li class="pull-right" title="Donations"><a href="<?php echo base_url(); ?>donations" class="js-right-sidebar" data-close="true"><i class="material-icons">attach_money</i></a></li>

                </ul>
          </div>

      </div>
  </nav>


  <!-- #Top Bar -->
  <section>
      <!-- Left Sidebar -->
      <aside id="leftsidebar" class="sidebar">


          <!-- Menu -->
          <div class="menu">
              <ul class="list">
                <li class="header">MAIN NAVIGATION</li>
                  <li <?php if (strpos($url,'dashboard') !== false){ ?> class="active" <?php } ?>>
                      <a href="<?php echo base_url(); ?>dashboard">
                          <i class="material-icons">home</i>
                          <span>Dashboard</span>
                      </a>
                  </li>

                  <li <?php if (strpos($url,'categoriesListing') !== false || strpos($url,'newCategory') !== false){ ?> class="active" <?php } ?>>
                      <a href="#categories"  data-toggle="collapse" class="menu-toggle" aria-expanded="false">
                          <i class="material-icons">pages</i>
                          <span>Categories</span>
                      </a>
                      <ul class="ml-menu">
                          <li>
                              <a href="<?php echo base_url(); ?>categoriesListing" title="categoryListing">Listing</a>
                          </li>
                          <li>
                              <a href="<?php echo base_url(); ?>newCategory" title="newCategory">Add New</a>
                          </li>

                      </ul>
                  </li>
                  <li <?php if (strpos($url,'SubCategory') !== false || strpos($url,'subcategoryListing') !== false){ ?> class="active" <?php } ?> style="display:none;">
                      <a href="#sub-categories"  data-toggle="collapse" class="menu-toggle" aria-expanded="false">
                          <i class="material-icons">pages</i>
                          <span>Sub Categories</span>
                      </a>
                      <ul class="ml-menu">
                          <li>
                              <a href="<?php echo base_url(); ?>subcategoryListing" title="SubCategoryListing">Listing</a>
                          </li>
                          <li>
                              <a href="<?php echo base_url(); ?>newSubCategory" title="newSubCategory">Add New</a>
                          </li>

                      </ul>
                  </li>
                  <li <?php if (strpos($url,'audio') !== false || strpos($url,'video') !== false){ ?> class="active" <?php } ?>>
                      <a href="#categories"  data-toggle="collapse" class="menu-toggle" aria-expanded="false">
                          <i class="material-icons">library_music</i>
                          <span>All Messages</span>
                      </a>
                      <ul class="ml-menu">
                        <li>
                            <a href="<?php echo base_url(); ?>videoListing" title="videoListing">Videos Listing</a>
                        </li>
                          <li>
                              <a href="<?php echo base_url(); ?>audioListing" title="audioListing">Audios Listing</a>
                          </li>

                          <li>
                              <a href="<?php echo base_url(); ?>newVideo" title="newVideo">New Video</a>
                          </li>

                          <li>
                              <a href="<?php echo base_url(); ?>newAudio" title="newAudio">New Audio</a>
                          </li>

                      </ul>
                  </li>

                  <li <?php if (strpos($url,'devotional') !== false || strpos($url,'devotional') !== false){ ?> class="active" <?php } ?>>
                      <a href="#categories"  data-toggle="collapse" class="menu-toggle" aria-expanded="false">
                          <i class="material-icons">library_books</i>
                          <span>Devotionals</span>
                      </a>
                      <ul class="ml-menu">
                          <li>
                              <a href="<?php echo base_url(); ?>devotionalsListing" title="devotionalsListing">Listing</a>
                          </li>
                          <li>
                              <a href="<?php echo base_url(); ?>newDevotional" title="newDevotional">New Devotional</a>
                          </li>

                      </ul>
                  </li>


                  <li <?php if (strpos($url,'hymn') !== false || strpos($url,'hymn') !== false){ ?> class="active" <?php } ?>>
                      <a href="#categories"  data-toggle="collapse" class="menu-toggle" aria-expanded="false">
                          <i class="material-icons">format_list_numbered</i>
                          <span>Hymns/Lyrics</span>
                      </a>
                      <ul class="ml-menu">
                          <li>
                              <a href="<?php echo base_url(); ?>hymnsListing" title="hymnsListing">Listing</a>
                          </li>
                          <li>
                              <a href="<?php echo base_url(); ?>newHymn" title="newDevotional">Add New</a>
                          </li>

                      </ul>
                  </li>


                  <li <?php if (strpos($url,'event') !== false || strpos($url,'event') !== false){ ?> class="active" <?php } ?>>
                      <a href="#events"  data-toggle="collapse" class="menu-toggle" aria-expanded="false">
                          <i class="material-icons">alarm</i>
                          <span>Church Events</span>
                      </a>
                      <ul class="ml-menu">
                          <li>
                              <a href="<?php echo base_url(); ?>events" title="events">Listing</a>
                          </li>
                          <li>
                              <a href="<?php echo base_url(); ?>newEvent" title="newEvent">Add New</a>
                          </li>

                      </ul>
                  </li>

                  <li <?php if (strpos($url,'inbox') !== false || strpos($url,'inbox') !== false){ ?> class="active" <?php } ?>>
                      <a href="#inbox"  data-toggle="collapse" class="menu-toggle" aria-expanded="false">
                          <i class="material-icons">message</i><span>Notifications</span>
                      </a>
                      <ul class="ml-menu">
                          <li>
                              <a href="<?php echo base_url(); ?>inbox" title="Messages">Listing</a>
                          </li>
                          <li>
                              <a href="<?php echo base_url(); ?>newInbox" title="newInbox">Send New</a>
                          </li>

                      </ul>
                  </li>

                  <li <?php if (strpos($url,'androidUsers') !== false || strpos($url,'usercomments') !== false  || strpos($url,'reportedcomments') !== false){ ?> class="active" <?php } ?>>
                      <a href="#android"  data-toggle="collapse" class="menu-toggle" aria-expanded="false">
                          <i class="material-icons">android</i><span>App Related</span>
                      </a>

                      <ul class="ml-menu">
                          <li>
                              <a href="<?php echo base_url(); ?>androidUsers" title="Android Users">Registered Android Users</a>
                          </li>
                          <li>
                              <a href="<?php echo base_url(); ?>usercomments" title="Users Comments">Users Comments</a>
                          </li>
                          <li>
                              <a href="<?php echo base_url(); ?>reportedcomments" title="Reported Comments">Reported Comments</a>
                          </li>

                      </ul>
                  </li>

                  <li <?php if (strpos($url,'coupons') !== false){ ?> class="active" <?php } ?>>
                      <a href="<?php echo base_url(); ?>branches" title="coupons">
                          <i class="material-icons">my_location</i>
                          <span>Church Branches</span>
                      </a>
                  </li>
                  <li <?php if (strpos($url,'coupons') !== false){ ?> class="active" <?php } ?>>
                      <a href="<?php echo base_url(); ?>bible" title="coupons">
                          <i class="material-icons">library_books</i>
                          <span>Bible</span>
                      </a>
                  </li>


                  <li <?php if (strpos($url,'adminListing') !== false || strpos($url,'newAdmin') !== false){ ?> class="active" <?php } ?> style="display:none;">
                      <a  data-toggle="collapse" class="menu-toggle" aria-expanded="false">
                          <i class="material-icons">account_circle</i>
                          <span>Admin Users</span>
                      </a>
                      <ul class="ml-menu">
                          <li>
                              <a href="<?php echo base_url(); ?>adminListing" title="adminListing">Listing</a>
                          </li>
                          <li>
                              <a href="<?php echo base_url(); ?>newAdmin" title="newAdmin">Add New</a>
                          </li>

                      </ul>
                  </li>
              </ul>
          </div>
          <!-- #Menu -->
          <!-- Footer -->
          <div class="legal">
              <div class="copyright">
                  &copy; <?php echo date('Y'); ?> <a href="javascript:void(0);">ChurchApp - Admin</a>.
              </div>

          </div>
          <!-- #Footer -->
      </aside>
      <!-- #END# Left Sidebar -->
  </section>
