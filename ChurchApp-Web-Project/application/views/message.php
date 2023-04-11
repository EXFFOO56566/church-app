<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
    <title>MYChurchApp</title>
    <!-- Favicon-->
  <link rel="icon" href="<?php echo asset_url('images/favicon.ico'); ?>" type="image/x-icon">

    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css?family=Roboto:400,700&subset=latin,cyrillic-ext" rel="stylesheet" type="text/css">
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet" type="text/css">

    <!-- Bootstrap Core Css -->
    <link href="<?php echo asset_url('plugins/bootstrap/css/bootstrap.css'); ?>" rel="stylesheet">

    <!-- Waves Effect Css -->
    <link href="<?php echo asset_url('plugins/node-waves/waves.css') ?>" rel="stylesheet">

    <!-- Custom Css -->
    <link href="<?php echo asset_url('css/style.css') ?>" rel="stylesheet">
</head>

<body class="error error_four">
  <section class="">
      <div class="">
          <!-- Basic Alerts -->
          <div class="">
              <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12" style="margin-top:60px;">
                  <div class="">

                      <div class="body">
                        <?php if(isset($status) && isset($message)) { ?>
                          <div class="align-center">
                              <?php if($status=="ok"){ ?>

                                <div class="alert alert-success align-center">
                                    <img src="<?php echo asset_url('images/success.png'); ?>" class="img-responsive center-block" style="height:150px; width:150px">
                                    <span style="font-size:25px;"><?php echo $message; ?></span>
                                </div>
                            <?php }else{ ?>
                                <div class="alert alert-danger align-center">
                                      <img src="<?php echo asset_url('images/error.png'); ?>" class="img-responsive center-block">
                                    <span style="font-size:25px;"><?php echo $message; ?></span>
                                </div>
                            <?php } ?>
                          </div>
                          <?php } ?>


                      </div>
                  </div>
              </div>
          </div>
          <!-- #END# Basic Alerts -->

      </div>
  </section>
    <!-- Jquery Core Js -->
    <script src="<?php echo asset_url('plugins/jquery/jquery.min.js') ?>"></script>

    <!-- Bootstrap Core Js -->
    <script src="<?php echo asset_url('plugins/bootstrap/js/bootstrap.js') ?>"></script>

</body>
</html>
