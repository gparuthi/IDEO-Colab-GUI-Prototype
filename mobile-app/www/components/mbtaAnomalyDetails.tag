<mbtadetails>
  <div>
  <dialog id={fid} class="mdl-dialog">
    <h4 class="mdl-dialog__title">Delays</h4>
    <div class="mdl-dialog__content">
      Minor delays on Red Line due to a disabled train.
    </div>
    <div class="mdl-dialog__actions">
      <button type="button" onclick={showAlternativesClick} class="mdl-button">Alternative Routes</button>
      <button type="button" class="mdl-button close">Close</button>
    </div>
  </dialog>
  </div>
  <script>
  var self = this

  self.fid = "mbtadialog"

    this.on("mount", ()=>{


      var dialog = document.querySelector("#"+self.fid);
      mbtadialog = dialog
      
      if (! dialog.showModal) {
        dialogPolyfill.registerDialog(dialog);
      }
      
      dialog.querySelector('.close').addEventListener('click', function() {
        dialog.close();
      });

    })

    showAlternativesClick(){
      window.open("transit://directions?from="+homeTag.from+"&to="+homeTag.to, "_system")
    }

    
  </script>
  <style :scoped>
   
  </style>
</mbtadetails>