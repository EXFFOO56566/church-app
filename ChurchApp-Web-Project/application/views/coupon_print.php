<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
    <link href="//maxcdn.bootstrapcdn.com/bootstrap/3.3.0/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">
    <script src="//maxcdn.bootstrapcdn.com/bootstrap/3.3.0/js/bootstrap.min.js"></script>
    <script src="//code.jquery.com/jquery-1.11.1.min.js"></script>
<!------ Include the above in your HEAD tag ---------->
<title> Coupons</title>
<link href="https://maxcdn.bootstrapcdn.com/font-awesome/4.4.0/css/font-awesome.min.css" rel="stylesheet">
<style type="text/css">
.coupon {
    border: 3px dashed #bcbcbc;
    border-radius: 10px;
    font-family: "HelveticaNeue-Light", "Helvetica Neue Light",
    "Helvetica Neue", Helvetica, Arial, "Lucida Grande", sans-serif;
    font-weight: 300;
}

.coupon #head {
    border-top-left-radius: 10px;
    border-top-right-radius: 10px;
    min-height: 56px;
}

.coupon #footer {
    border-bottom-left-radius: 10px;
    border-bottom-right-radius: 10px;
}

#title .visible-xs {
    font-size: 12px;
}

.coupon #title img {
    font-size: 30px;
    height: 30px;
    margin-top: 5px;
}

@media screen and (max-width: 500px) {
    .coupon #title img {
        height: 15px;
    }
}

.coupon #title span {
    float: right;
    margin-top: 5px;
    font-weight: 700;
    text-transform: uppercase;
}

.coupon-img {
    width: 100%;
    margin-bottom: 15px;
    padding: 0;
}

.items {
    margin: 15px 0;
}

.usd, .cents {
    font-size: 20px;
}

.number {
    font-size: 40px;
    font-weight: 700;
}

sup {
    top: -15px;
}

#business-info ul {
    margin: 0;
    padding: 0;
    list-style-type: none;
    text-align: center;
}

#business-info ul li {
    display: inline;
    text-align: center;
}

#business-info ul li span {
    text-decoration: none;
    padding: .2em 1em;
}

#business-info ul li span i {
    padding-right: 5px;
}

.disclosure {
    padding-top: 15px;
    font-size: 11px;
    color: #bcbcbc;
    text-align: center;
}

.coupon-code {
    color: #333333;
    font-size: 11px;
}

.exp {
    color: #f34235;
}

.print {
    font-size: 14px;
    float: right;
}



/*------------------dont copy these lines----------------------*/
body {
    font-family: "HelveticaNeue-Light", "Helvetica Neue Light",
    "Helvetica Neue", Helvetica, Arial, "Lucida Grande", sans-serif;
    font-weight: 300;
}
.row {
    margin: 30px 0;
}

#quicknav ul {
    margin: 0;
    padding: 0;
    list-style-type: none;
    text-align: center;
}

#quicknav ul li {
    display: inline;
}

#quicknav ul li a {
    text-decoration: none;
    padding: .2em 1em;
}

.btn-danger,
.btn-success,
.btn-info,
.btn-warning,
.btn-primary {
    width: 105px;
}

.btn-default {
    margin-bottom: 40px;
}
/*-------------------------------------------------------------*/
</style>
</head>

<body>

  <div class="container">

    <div class="row"><h1 class="text-center">Generated Coupons </h1><small> <a href="<?php echo site_url(); ?>coupons">BACK</a></small>
    </div>

    <div id="quicknav">
        <ul>
            <li><span class="print">
                <a onclick="printDiv('printMe')" class="btn btn-link"><i class="fa fa-lg fa-print"></i> Print Coupons</a>
            </span></li>
        </ul>
    </div>

	<div id='printMe' class="row">


        <?php
        forEach($print_data as $record){
          //var_dump($record); die;
        ?>

        <div class="col-md-6 col-md-offset-3">
            <div class="panel panel-default coupon">
              <div class="panel-heading" id="head">
                <div class="panel-title" id="title">
                    <span class="hidden-xs"><?php echo $record['duration']; ?> Subscription</span>
                    <span class="visible-xs"><?php echo $record['duration']; ?> Subscription</span>
                </div>
              </div>
              <div class="panel-body">
                <div class="col-md-9">
                  <p class="disclosure">Download MyChurch Mobile App from google playstore, enter this coupon code
                    to enjoy video and audio streaming.</p>
                </div>
                <div class="col-md-3">
                    <div class="offer">
                        <span><h4><?php echo $record['currency'].$record['amount']; ?></h4></span>
                    </div>
                </div>

              </div>
              <div class="panel-footer">
                <div class="coupon-code">
                    Code: <b><?php echo $record['code']; ?></b>

                </div>
                <div class="exp">Expires: <?php echo $record['expiry']; ?></div>
              </div>
            </div>
     </div>


       <?php }
       ?>


    </div>


    <p class="text-center"><a href="#" class="btn btn-default">Back to top <i class="fa fa-chevron-up"></i></a></p>

</div>

<script>
   function printDiv(divName){
			var printContents = document.getElementById(divName).innerHTML;
			var originalContents = document.body.innerHTML;

			document.body.innerHTML = printContents;

			window.print();

			document.body.innerHTML = originalContents;

		}
</script>

</body>

</html>
