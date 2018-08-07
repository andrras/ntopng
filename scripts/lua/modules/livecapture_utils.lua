--
-- (C) 2014-18 - ntop.org
--

-- This file contains functions used to run live captures 

function drawHostLiveCaptureButton(if_id, host_info)

  print [[
<div id="hostLiveCaptureModal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="hostLiveCaptureModal_label" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">x</button>
        <h3>]] print(i18n("live_capture.live_capture")) print[[</h3>
      </div>

      <div class="modal-body">
        <div class="alert alert-info"> ]] print(i18n("live_capture.note", {hostinfo=host_info["host"]})) print[[</div>
      </div>
      <div class="modal-footer">
        <!--button class="btn btn-default" data-dismiss="modal" aria-hidden="true">]] print(i18n("close")) print[[</button-->
        <button type="submit" class="btn btn-primary" name="start" onclick="hostLiveCapture()">]] print(i18n("start")) print[[</button>
        <button type="submit" class="btn btn-primary" name="stop" onclick="stopHostLiveCapture()" disabled>]] print(i18n("stop")) print[[</button>
      </div>
    </div>
  </div>
</div>
      
<a href='#' onclick="$('#hostLiveCaptureModal').modal('show');">pcap</a>

<script>
  var updateHostLiveCaptureStatus_started = 0;
  function updateHostLiveCaptureStatus() {
    $.ajax({
      type: 'GET',
      url: ']] print(ntop.getHttpPrefix().."/lua/live_traffic.lua") print[[',
      data: { 
        ifid: ']] print(tostring(if_id)) print [[',
        host: ']] print(host_info["host"]) print [[',
        action: 'status',
        csrf: ']] print(ntop.getRandomCSRFValue()) print[['
      },
      success: function(status) {
        if (status.status == 'running') {
          $("#hostLiveCaptureModal button[name=start]").prop('disabled', true);
          $("#hostLiveCaptureModal button[name=stop]").prop('disabled', false);
        } else {
          $("#hostLiveCaptureModal button[name=start]").prop('disabled', false);
          $("#hostLiveCaptureModal button[name=stop]").prop('disabled', true);
        }
      }
    });
  }

  function hostLiveCapture() {
    var params = {};

    params.ifid = "]] print(tostring(if_id)) print[[";
    params.host = "]] print(host_info["host"]) print[[";
    params.action = 'start';
    $("#hostLiveCaptureModal button[name=start]").prop('disabled', true);
    $("#hostLiveCaptureModal button[name=stop]").prop('disabled', false);
    params.csrf = "]] print(ntop.getRandomCSRFValue()) print[[";
 
    var form = paramsToForm('<form action="]] print(ntop.getHttpPrefix().."/lua/live_traffic.lua") print[[" method="get"></form>', params);
    form.appendTo('body').submit();

    if (!updateHostLiveCaptureStatus_started) {
      updateHostLiveCaptureStatus_started = 1;
      setInterval(updateHostLiveCaptureStatus, 2000);
    }
  }

  function stopHostLiveCapture() {
    $.ajax({
      type: 'GET',
      url: ']] print(ntop.getHttpPrefix().."/lua/live_traffic.lua") print[[',
      data: { 
        ifid: ']] print(tostring(if_id)) print [[',
        host: ']] print(host_info["host"]) print [[',
        action: 'stop',
        csrf: ']] print(ntop.getRandomCSRFValue()) print[['
      },
      success: function(content) {
        $("#hostLiveCaptureModal button[name=start]").prop('disabled', false);
        $("#hostLiveCaptureModal button[name=stop]").prop('disabled', true);
      }
    });
  }

</script>
]]

end
