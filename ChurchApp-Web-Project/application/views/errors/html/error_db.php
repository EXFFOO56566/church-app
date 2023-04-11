<?php
defined('BASEPATH') OR exit('No direct script access allowed');
?>
<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
    <title>404</title>
    <!-- Favicon-->
    <link rel="icon" href="../../../favicon.png" type="image/x-icon">

    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css?family=Roboto:400,700&subset=latin,cyrillic-ext" rel="stylesheet" type="text/css">
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet" type="text/css">

    <!-- Bootstrap Core Css -->
    <link href="../../../assets/plugins/bootstrap/css/bootstrap.css" rel="stylesheet">

    <!-- Custom Css -->
    <link href="../../../assets/css/style.css" rel="stylesheet">
</head>

<body class="error error_four">
    <div class="error-box">
        <img src="../../../assets/images/404.png" class="img-responsive center-block" alt="404">
        <div class="error-message">
					<?php echo $heading; ?>
					<?php echo $message; ?>
        </div>
        <div class="error-bottom">
            <a href="javascript: history.back();" class="btn btn-primary">Hey, Take Me Home</a>
            <div class="report-error">
            </div>
        </div>
    </div>

    <!-- Jquery Core Js -->
    <script src="../../../assets/plugins/jquery/jquery.min.js"></script>

    <!-- Bootstrap Core Js -->
    <script src="../../../assets/plugins/bootstrap/js/bootstrap.js"></script>
</body>

</html>
