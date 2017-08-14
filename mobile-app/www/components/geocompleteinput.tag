<geocompleteinput>
   <div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label">
    <span class="tblabel"><i class="fa fa-location-arrow" aria-hidden="true"></i> {opts.fid} </span>
    <input class="mdl-textfield__input" id={"geocomplete"+opts.fid} type="text" onchange={textChanged} onclick={findClick} placeholder="Type in an address" value={value} size="20"/>
  </div>

 


<script>
  geoTag = this
  var self = this
  self.value = opts.value

  this.on("mount", function(){
        self.fid = "#geocomplete"+opts.fid
        console.log(self.fid)      
        // self.setupUpdateTFResult()
        $("#geocomplete"+opts.fid).geocomplete()
          .bind("geocode:result", function(event, result){
            console.log("Result: " + result.formatted_address);
            self.value = result.formatted_address
          })
          .bind("geocode:error", function(event, status){
            console.log("ERROR: " + status);
          })
          .bind("geocode:multiple", function(event, results){
            console.log("Multiple: " + results.length + " results found");
          });
    })

  textChanged(e){
    self.findClick()
    self.value = e.target.value
    console.log(self.value)
  }
  findClick(){
    $("#geocomplete"+opts.fid).trigger("geocode");
  }
    
</script>

<style>
  .mdl-textfield {
    padding: 0px;
  }
  .mdl-textfield__input{
    position: absolute;
    top: 0px;
    margin-left: 60px
  }
  .tblabel{
    font-size: 10pt;
  }
</style>
</geocompleteinput>