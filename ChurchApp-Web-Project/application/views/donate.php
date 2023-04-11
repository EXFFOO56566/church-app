<html>
<head>
<title> Donate </title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href="//maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">
<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.0.8/css/all.css">
<script type="text/javascript">
        var baseURL = "<?php echo base_url(); ?>";
    </script>
</head>
<body>


  <div class="container">
  <br>  <p class="text-center">Donate to Mychurch App</p>
  <br>

  <div class="row">
  	<div class="col-sm-10">
  <article class="card">
  <div class="card-body p-5">

  <ul class="nav bg-light nav-pills rounded nav-fill mb-3" role="tablist">
  	<li class="nav-item" <?php if($settings->paystack_key == ""){ ?> style="display:none;" <?php } ?>>
  		<a class="nav-link <?php if($settings->paystack_key != '') echo ' active'; ?>" data-toggle="pill" href="#nav-tab-card">
  	 Paystack</a></li>
  	<li class="nav-item" <?php if($settings->flutterwaves_key == ""){ ?> style="display:none;"<?php } ?>>
  		<a class="nav-link <?php if($settings->paystack_key == '' && $settings->flutterwaves_key != '') echo ' active'; ?>" data-toggle="pill" href="#nav-tab-paypal">
  		 FlutterWaves</a></li>
  	<li class="nav-item" <?php if($settings->paypal_link == ""){ ?> style="display:none;"<?php } ?>>
  		<a class="nav-link <?php if($settings->paystack_key == '' && $settings->flutterwaves_key == '' && $settings->paypal_link != "") echo ' active'; ?>" data-toggle="pill" href="#nav-tab-paypalform">
  		 PayPal</a></li>

  </ul>

  <div class="tab-content">
  <div class="tab-pane fade <?php if($settings->paystack_key != '') echo 'show active'; ?>" id="nav-tab-card" <?php if($settings->paystack_key == ""){ ?> style="display:none;"<?php } ?>>
  	<p style="display:none;" class="alert alert-success">Some text success or error</p>
  	<form role="form" id="paymentForm">
      <div class="form-group">
    		<label for="username">Reason for donation</label>
    		<input type="text" class="form-control" id="reason" name="reason" placeholder="" required="">
    	</div>
      <div class="form-group">
    		<label for="username">Email Address</label>
    		<input type="email" id="email-address" class="form-control" name="email" placeholder="" required="">
    	</div>
      <div class="row">
      <div class="col-sm-6">
        <div class="form-group">
      		<label for="username">First Name</label>
      		<input type="text" id="first-name" class="form-control" name="name" placeholder="" required="">
      	</div>
      </div>
      <div class="col-sm-6">
        <div class="form-group">
          <label for="username">Last Name</label>
          <input type="text" id="last-name" class="form-control" name="name" placeholder="" required="">
        </div>
      </div>
     </div>
  	 <!-- form-group.// -->
    <div class="form-group">
  		<label for="username">Amount</label>
  		<input type="number" id="amount" class="form-control" name="amount" placeholder="" required="">
  	</div>




  	<button onclick="payWithPaystack(event)" class="subscribe btn btn-primary btn-block" type="button"> Proceed With Paystack  </button>
  	</form>
  </div> <!-- tab-pane.// -->



  <div class="tab-pane fade <?php if($settings->paystack_key == '' && $settings->flutterwaves_key != '') echo 'show active'; ?>" id="nav-tab-paypal" <?php if($settings->flutterwaves_key == ""){ ?> style="display:none;"<?php } ?>>
    <form role="form" id="paymentForm2">
      <div class="form-group">
    		<label for="username">Reason for donation</label>
    		<input type="text" class="form-control" id="raves-reason" name="raves-reason" placeholder="" required="">
    	</div>
      <div class="form-group">
    		<label for="username">Email Address</label>
    		<input type="email" id="raves-email-address" class="form-control" name="email" placeholder="" required="">
    	</div>
      <div class="row">
      <div class="col-sm-6">
        <div class="form-group">
      		<label for="username">First Name</label>
      		<input type="text" id="raves-first-name" class="form-control" name="name" placeholder="" required="">
      	</div>
      </div>
      <div class="col-sm-6">
        <div class="form-group">
          <label for="username">Last Name</label>
          <input type="text" id="raves-last-name" class="form-control" name="name" placeholder="" required="">
        </div>
      </div>
     </div>
  	 <!-- form-group.// -->
    <div class="form-group">
  		<label for="username">Amount</label>
  		<input type="number" id="raves-amount" class="form-control" name="amount" placeholder="" required="">
  	</div>




  	<button onclick="makePayment(event)" class="subscribe btn btn-primary btn-block" type="button"> Proceed With FlutterWaves  </button>
  	</form>
  </div>


  <div class="tab-pane fade <?php if($settings->paystack_key == '' && $settings->flutterwaves_key == '' && $settings->paypal_link != "") echo 'show active'; ?>" id="nav-tab-paypalform" <?php if($settings->paypal_link == ""){ ?> style="display:none;"<?php } ?>>
      <br><br><br>
      <div class="row">
        <aside class="col-sm-2">
        </aside>
      	<aside class="col-sm-8">
        <a href="<?php echo $settings->paypal_link; ?>">
          <img src="<?php echo asset_url('images/paypal.png'); ?>" class="img-responsive" width="300">
          <button class="subscribe btn btn-primary btn-block" type="button"> Make a donation with With PayPal  </button>
        </a>
      </div>
  </div>


  </div> <!-- tab-content .// -->

  </div> <!-- card-body.// -->
  </article> <!-- card.// -->


  	</aside> <!-- col.// -->
  </div> <!-- row.// -->

  </div>
  <!--container end.//-->


</body>
<script src="//cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<script src="//maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>
<script src="https://unpkg.com/@popperjs/core@2"></script>
<script src="https://js.paystack.co/v1/inline.js"></script>
<script src="https://checkout.flutterwave.com/v3.js"></script>
<script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
<script src="<?php echo asset_url('js/ajax.js') ?>"></script>
<script>
var paymentForm = document.getElementById('paymentForm');
paymentForm.addEventListener("submit", payWithPaystack, false);
function payWithPaystack(e) {
  e.preventDefault();

  var reason = document.getElementById("reason").value;
  var amount = document.getElementById("amount").value;
  var email = document.getElementById("email-address").value;
  var firstname = document.getElementById("first-name").value;
  var lastname = document.getElementById("last-name").value;

  if (reason == "") {
      swal("ooops", "You forgot to let us know the reason for the donation.", "error");
      return;
  }

  if (email == "") {
      swal("ooops", "You forgot to fill the email field.", "error");
      return;
  }
  if (firstname == "") {
      swal("ooops", "You forgot to fill the First Name field.", "error");
      return;
  }
  if (lastname == "") {
      swal("ooops", "You forgot to fill the Last Name field.", "error");
      return;
  }
  if (amount <= 0) {
      swal("ooops", "You need to enter a valid amount you want to donate.", "error");
      return;
  }

  let handler = PaystackPop.setup({
    key: '<?php echo $settings->paystack_key; ?>',
    email: email,
    amount: amount * 100,
    firstname: firstname,
    lastname: lastname,
    onClose: function(){

    },
    callback: function(response){
      console.log(response);
      senddonationtoserver(email,firstname+" "+lastname,amount,response.trxref,"Paystack",reason);
    }
  });
  handler.openIframe();
}

//FlutterWaves
function makePayment(e) {
    e.preventDefault();
    var reason = document.getElementById("raves-reason").value;
    var amount = document.getElementById("raves-amount").value;
    var email = document.getElementById("raves-email-address").value;
    var firstname = document.getElementById("raves-first-name").value;
    var lastname = document.getElementById("raves-last-name").value;
    var ref = "FLWSECK_"+Math.floor((Math.random() * 1000000000) + 1);

    if (reason == "") {
        swal("ooops", "You forgot to let us know the reason for the donation.", "error");
        return;
    }
    if (email == "") {
        swal("ooops", "You forgot to fill the email field.", "error");
        return;
    }
    if (firstname == "") {
        swal("ooops", "You forgot to fill the First Name field.", "error");
        return;
    }
    if (lastname == "") {
        swal("ooops", "You forgot to fill the Last Name field.", "error");
        return;
    }
    if (amount <= 0) {
        swal("ooops", "You need to enter a valid amount you want to donate.", "error");
        return;
    }
    FlutterwaveCheckout({
      public_key: '<?php echo $settings->flutterwaves_key; ?>',
      tx_ref: ref,
      amount: amount,
      currency: '<?php echo $settings->flutterwaves_currency_code; ?>',
      //payment_options: "card, mobilemoneyghana, ussd",
      redirect_url: baseURL+"thank_you",
      customer: {
        email: email,
        name: firstname + " "+lastname,
      },
      callback: function (data) {
        console.log(data);
        senddonationtoserver(email,firstname+" "+lastname,amount,ref,"FlutterWave",reason);
      },
      onclose: function() {
        // close modal
      },
    });
  }

  function senddonationtoserver(email,name,amount,ref,method,reason){
    swal({
      text: "Please wait while we complete your transaction..",
    });
    var form_obj = JSON.stringify({
      email:email,
      name: name,
      amount:amount,
      reference: ref,
      method: method,
      reason:reason
    });
    //console.log(form_obj); return;
    var fd = new FormData();
    fd.append("data", form_obj);

    makeAjaxCall( baseURL+"saveDonation", "POST",fd).then(function(response){
         window.location.href = baseURL+"thank_you";
    },  function(status){
       console.log("failed with status", status);
        window.location.href = baseURL+"thank_you";
    });
  }

</script>
</html>
