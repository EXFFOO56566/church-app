<section class="content">
    <div class="container-fluid">
        <div class="block-header">
            <h2>Donation Api Settings</h2>
        </div>
    <!-- Page content-->
    <div class="content-wrapper">
        <div class="container-fluid">

            <div class="row clearfix">
                <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                    <div class="card">

                        <div class="body">
                          <div class="card-inner">
                          <form method="POST" action="<?php echo base_url(); ?>updatedonationSettings">


                            <div class="input-group addon-line">
                                <label>Paystack Api Key (Leave Empty if not using Paystack)</label>
                                <div class="form-line">
                                    <input type="text" class="form-control" name="paystack_key" placeholder="" autofocus="" value="<?php echo $settings->paystack_key; ?>">
                                </div>
                            </div>


                            <div class="input-group addon-line">
                                <label>FlutterWaves Api Key (Leave Empty if not using FlutterWaves)</label>
                                <div class="form-line">
                                    <input type="text" class="form-control" name="flutterwaves_key" placeholder="" autofocus="" value="<?php echo $settings->flutterwaves_key; ?>">
                                </div>
                            </div>

                            <div class="input-group addon-line">
                                <label>FlutterWaves Currency Code (Leave Empty if not using FlutterWaves)</label>
                                <div class="form-line">
                                    <input type="text" class="form-control" name="flutterwaves_currency_code" placeholder="" autofocus="" value="<?php echo $settings->flutterwaves_currency_code; ?>">
                                </div>
                            </div>

                            <div class="input-group addon-line">
                                <label>PayPal Donation URL (Leave Empty if not using PayPal)</label>
                                <div class="form-line">
                                    <input type="text" class="form-control" name="paypal_link" placeholder="" autofocus="" value="<?php echo $settings->paypal_link; ?>">
                                </div>
                            </div>




                             <?php $this->load->helper('form'); ?>
                             <div class="row">
                                 <div class="col-md-12">
                                     <?php echo validation_errors('<div class="alert alert-danger alert-dismissable">', ' <button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button></div>'); ?>
                                 </div>
                             </div>
                             <?php
                             $this->load->helper('form');
                             $error = $this->session->flashdata('error');
                             if($error)
                             {
                                 ?>
                                 <div class="alert alert-danger alert-dismissable">
                                     <button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
                                     <?php echo $error; ?>
                                 </div>
                             <?php }
                             $success = $this->session->flashdata('success');
                             if($success)
                             {
                                 ?>
                                 <div class="alert alert-success alert-dismissable">
                                     <button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
                                     <?php echo $success; ?>
                                 </div>
                             <?php } ?>

                            <div class="box-footer text-center">
                               <button class="btn btn-primary waves-effect" type="submit">UPDATE API SETTINGS</button>
                            </div>

                          </form>
                        </div>
                      </div>
                    </div>
            </div>
    </div>
</section>
