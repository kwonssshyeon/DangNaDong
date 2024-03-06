/**
 * myPage js파일
 */
      $(function () {
        $("#navbar").load("layout/navbar.html");
        $("#footer").load("layout/footer.html");
      });
      
   // 팝업을 보여주는 함수
      function showPopup(popupId) {
        var popup = document.getElementById(popupId);
        popup.style.display = "block";
      }

      // 팝업을 숨기는 함수
      function hidePopup(popupId) {
        var popup = document.getElementById(popupId);
        popup.style.display = "none";
      }
     
      
      function chooseFile() {
          document.getElementById('fileInput').click();
      }

      function handleFileSelect(input) {
          var file = input.files[0];

          if (file) {
              var reader = new FileReader();

              reader.onload = function (e) {
                  var imgBtu = document.querySelector('.imgBtu');
                  var selectedImage = document.getElementById('selectedImage');

                  imgBtu.style.background = 'none'; // 숨김 처리
                  selectedImage.src = e.target.result;
                  selectedImage.style.display = 'block'; // 보이기 처리
              };

              reader.readAsDataURL(file);
          }
      }
