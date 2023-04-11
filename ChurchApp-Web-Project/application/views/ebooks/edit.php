<section class="content">
    <!-- Page content-->
    <div class="container-fluid">
        <div class="block-header">
            <h2>Edit Ebook</h2>
        </div>


            <div class="row clearfix">
                <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                    <div class="card">

                        <div class="body">
                          <div class="card-inner">
                          <form method="POST" action="<?php echo base_url(); ?>editEbookData" enctype="multipart/form-data" style="margin-top:30px;">
                            <input type="hidden" name="id" value="<?php echo $ebook->id; ?>">
                            <div class="addon-line">

                                <div class="form-line">
                                  <label>Ebook Category</label>
                                  <select class="form-control" id="category" name="category" required="" autofocus="">
                                    <?php foreach ($categories as $res) { ?>
                                      <option value="<?php echo $res->id; ?>" <?php echo $ebook->category_id==$res->id?"selected":""; ?>><?php echo $res->name; ?></option>
                                    <?php  } ?>
                                  </select>
                                </div>
                            </div>
                            <div class="addon-line" style="margin-top:20px; display:none;">

                                <div class="form-line">
                                  <label>Ebook SubCategory</label>
                                  <select class="form-control" id="subcategories" name="subcategories">
                                    <option value="0">Select SubCategory</option>
                                    <?php foreach ($subcategories as $res) { ?>
                                      <option value="<?php echo $res->id; ?>" <?php echo $ebook->sub_category==$res->id?"selected":""; ?>><?php echo $res->name; ?></option>
                                    <?php  } ?>
                                  </select>
                                </div>
                            </div>
                            <div class="input-group addon-line" style="margin-top:20px;">

                                <div class="form-line">
                                    <input type="text" class="form-control" name="name" value="<?php echo $ebook->name; ?>" placeholder="Ebook Title" required="" autofocus="">
                                </div>
                            </div>

                            <div class="input-group addon-line" style="margin-top:20px;">

                              <div class="form-line">
                                  <input data-default-file="<?php echo $ebook->url; ?>" type="file" name="pdf" data-allowed-file-extensions="pdf PDF" class="pdf_dropify" >
                              </div>
                            </div>

                            <div class="input-group addon-line" style="margin-top:20px;">

                                <div class="form-line">
                                    <input type="text" class="form-control" name="_thumbnail" value="<?php echo $ebook->thumbnail; ?>" placeholder="Enter Ebook CoverPhoto url Or Upload Image Below">
                                </div>

                                <div class="form-line">
                                    <input data-default-file="<?php echo $ebook->_thumbnail; ?>" type="file" name="thumbnail" data-allowed-file-extensions="png jpg jpeg PNG" class="thumbs_dropify" >
                                </div>
                            </div>

                            <div class="input-group addon-line" style="margin-top:20px;">

                                <div class="form-line">
                                    <input type="text" class="form-control" name="author" value="<?php echo $ebook->author; ?>" placeholder="Ebook Author" >
                                </div>
                            </div>

                            <div class="input-group addon-line" style="margin-top:20px; display:none;">

                                <div class="form-line">
                                    <input type="number" class="form-control" name="pages" value="<?php echo $ebook->pages; ?>" placeholder="Ebook Pages" >
                                </div>
                            </div>

                            <div class="input-group addon-line" style="margin-top:20px; display:none;" >

                                <div class="form-line">
                                    <input type="text" class="form-control" name="size" placeholder="Ebook Size" value="<?php echo $ebook->size; ?>">
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
                               <button class="btn btn-primary waves-effect" type="submit">UPDATE EBOOK</button>
                            </div>

                          </form>
                        </div>
                      </div>
                    </div>
                </div>
    </div>
</section>
