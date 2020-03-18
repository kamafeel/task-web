function Load(config) {
  if (!config) config = {};
  this.text = config.text || '加载中。。。';
  this.type = config.type || 'info';
  this.time = config.time || 2000;
  this.auto = typeof config.auto === 'undefined' ? true : config.auto;
  this.init();
}

Load.prototype.init = function () {
  var text = this.text;
  var type = this.type;
  var auto = this.auto;
  var colorData = {
    'info': {'bg': '#71b7e6', 'color': '#47b2bf', 'icon': '( ¯ □ ¯ )'},
    'success': {'bg': '#60d8ba', 'color': '#00cf9b', 'icon': '^_^o ~~~ '},
    'warn': {'bg': '#e1e102', 'color': '#fefc6f', 'icon': '╯﹏╰'},
    'error': {'bg': '#ff8686', 'color': '#fb6362', 'icon': 'o(╥﹏╥)o'},
  };
  var bg = colorData[type]['bg'];
  var color = colorData[type]['color'];
  var icon = colorData[type]['icon'];
  var centerEle = document.createElement('div');
  centerEle.style = 'height: 84px; opacity: 1';
  var html = '<div style="margin-bottom: 14px; width: 250px; height: 70px; box-shadow: 0px 0px 5px #ccc; background: #fff; border-radius: 4px; overflow: hidden; opacity: 1">'
    + '<div style="width: 100%; height: 20px; background-color: ' + bg + '">'
    + '<span style="margin-left:10px; color: #fff; font-size: 12px; float: left; line-height: 20px; font-weight: bold">' + icon + '</span>'
    + '<span style="margin-right:10px; color: #fff; cursor: pointer; font-size: 12px; float: right; line-height: 18px">×</span>'
    + '</div><div style="height: calc(100% - 20px); overflow: auto">'
    + '<div style="text-align: left; line-height: 18px; padding: 12px; color: #777777; font-size: 12px; margin: 0px;">' + text + '</div></div></div>';
  centerEle.innerHTML = html;

  var contentEle = document.querySelector('body');
  var windowEle = document.querySelector('#message_window');
  if (!windowEle) {
    windowEle = document.createElement('div');
    windowEle.style = 'width: 252px; position: fixed; right: 45%; top: 30%;z-index:999999';
    windowEle.id = 'message_window';
    contentEle.appendChild(windowEle);
  }
  this.centerEle = centerEle;
  windowEle.appendChild(centerEle);

  if (auto) this.autoClose();
  this.addCloseEvent();
};

Load.prototype.autoClose = function () {
  var time = this.time;
  var self = this;
  this.closeTime = setTimeout(function () {
    self.animate();
  }, time);
};

Load.prototype.addCloseEvent = function () {
  var centerEle = this.centerEle;
  var closeEle = centerEle.querySelectorAll('span')[1];
  var self = this;
  closeEle.addEventListener('click', function () {
    clearTimeout(self.closeTime);
    self.animate();
  });
};

Load.prototype.animate = function () {
  var centerEle = this.centerEle;
  var time = setInterval(heightLess, 6);

  function heightLess() {
    centerEle.style.opacity = parseFloat(centerEle.style.opacity) - 0.02;
    centerEle.style.height = centerEle.offsetHeight - 1 + 'px';
    if (centerEle.offsetHeight <= 0) {
      clearInterval(time);
      if (centerEle.parentNode) {
        centerEle.parentNode.removeChild(centerEle);
      }
    }
  }
};