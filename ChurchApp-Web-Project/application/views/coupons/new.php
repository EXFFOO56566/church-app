<section class="content">
    <div class="container-fluid">
        <div class="block-header">
          <h2>Generate coupon codes</h2>
        </div>
    <!-- Page content-->
    <div class="content-wrapper">
        <div class="container-fluid">

            <div class="row clearfix">
                <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                    <div class="card">

                        <div class="body">
                          <div class="card-inner">
                          <form method="POST" action="<?php echo base_url(); ?>generatecoupons">

                            <div class="addon-line" style="margin-top:0px;">

                                <div class="form-line">
                                  <label>Coupon Duration</label>
                                    <select class="form-control" name="duration" required="" autofocus="">
                                        <option value="One Week">One Week</option>
                                        <option value="One Month">One Month</option>
                                        <option value="Three Months">Three Months</option>
                                        <option value="Six Months">Six Months</option>
                                        <option value="One Year">One Year</option>
                                    </select>
                                </div>
                            </div>

                            <div class="input-group addon-line" style="margin-top:20px;">
                                <label>Currency symbol</label>
                                <div class="form-line">
                                    <input type="text" value="$" class="form-control" name="currency" placeholder="" required="" autofocus="">
                                </div>
                            </div>

                            <div class="input-group addon-line" style="margin-top:20px;">
                                <label>Amount for this coupon</label>
                                <div class="form-line">
                                    <input type="number" step="any"  value="0.00" class="form-control" name="amount" placeholder="Amount this coupon is worth" required="" autofocus="">
                                </div>
                            </div>

                            <div class="input-group addon-line" style="margin-top:20px;">
                                <label>Number of Coupon Codes to Generate</label>
                                <div class="form-line">
                                    <input type="number" value="20" class="form-control" name="total" placeholder="Number of codes to generate" required="" autofocus="">
                                </div>
                            </div>

                            <div class="input-group addon-line" style="margin-top:20px;">
                                <label>Coupon Expiry Date(Users wont be able to use this coupon after this date)</label>
                                <div class="form-line">
                                    <input type="date" class="form-control" name="expiry" placeholder="LiveTv CoverPhoto" required="" autofocus="">
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


                            <div class="box-footer text-center" style="margin-top:20px;">
                               <button  class="btn btn-primary waves-effect" type="submit">GENERATE</button>

                            </div>

                          </form>
                        </div>
                      </div>
                    </div>
                </div>
    </div>
</section>
