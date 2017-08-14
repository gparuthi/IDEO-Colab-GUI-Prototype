<settings>
	<div>
		Test
		<button class="mdl-button mdl-js-button" onclick={sendSampleNotification} ><span>Send Notification</span></button>
	</div>
	<script>
		settingsTag = this
		var self = this
		
		sendSampleNotification(){
			var localNotification = {
			        id: 100,
			        title: 'GUI Anomaly',
			        text: 'There is only 10% likelihood of you finding a seat today.'
			      }
	      cordova.plugins.notification.local.schedule(localNotification);
		}
	</script>
</settings>