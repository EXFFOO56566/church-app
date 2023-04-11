<section class="content">
    <!-- Page content-->
    <div class="container-fluid">
        <div class="block-header">
            <h2>Add New SubCategory</h2>
        </div>


            <div class="row clearfix">
                <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                    <div class="card">

                        <div class="body">
                          <div class="card-inner">
                          <form method="POST" action="<?php echo base_url(); ?>savenewsubcategory" style="margin-top:30px;">
                            <div class="addon-line" >

                              <div class="addon-line" >

                                  <div class="form-line">
                                    <label>Category Group</label>
                                    <select class="form-control" id="cat_group" name="cat_group" required="" autofocus="">
                                    <option value="">Select Category Group</option>
                                    <option value="videos">Category For Videos</option>
                                    <option value="audios">Category For Audios</option>
                                    <option value="books">Category For Books</option>
                                    <option value="articles">Category For Articles</option>
                                    </select>
                                  </div>
                              </div>

                                <div class="form-line" style="margin-top:20px;">
                                  <label>Category</label>
                                  <select class="form-control" id="category_id" name="category_id" required="" autofocus="">
                                    <option value="">Select Category</option>
                                  </select>
                                </div>
                            </div>
                            <div class="input-group addon-line" style="margin-top:20px;">

                                <div class="form-line">
                                    <input type="text" class="form-control" name="name" placeholder="SubCategory Name" required="" autofocus="">
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
                               <button class="btn btn-primary waves-effect" type="submit">SAVE NEW SUBCATEGORY</button>
                            </div>

                          </form>
                        </div>
                      </div>
                    </div>
                </div>
    </div>
</section>
