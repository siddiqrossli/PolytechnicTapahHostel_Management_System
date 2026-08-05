// ======================
// GLOBAL VARIABLES & INIT
// ======================
let icon, count;

// ======================
// UTILITY FUNCTIONS
// ======================
function isElementInViewport(el) {
  if (typeof jQuery === "function" && el instanceof jQuery) {
    el = el[0];
  }
  const rect = el.getBoundingClientRect();
  return (
    (rect.top <= 0 && rect.bottom >= 0) ||
    (rect.bottom >= (window.innerHeight || document.documentElement.clientHeight) &&
    rect.top <= (window.innerHeight || document.documentElement.clientHeight)) ||
    (rect.top >= 0 && rect.bottom <= (window.innerHeight || document.documentElement.clientHeight))
  );
}

function isMobileDevice() {
  return /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent);
}

// ======================
// ANIMATION CONTROLLERS
// ======================
function initScrollAnimations() {
  const animationTypes = ['', '2', '3'];
  
  animationTypes.forEach(type => {
    const scroll = window.requestAnimationFrame || 
      function(callback) { window.setTimeout(callback, 1000/60) };
    
    const elements = document.querySelectorAll(`.show-on-scroll${type}`);
    
    function loop() {
      Array.prototype.forEach.call(elements, function(element) {
        if (isElementInViewport(element)) {
          element.classList.add(`is-visible${type}`);
        }
      });
      scroll(loop);
    }
    loop();
  });
}

// ======================
// UI COMPONENTS
// ======================
function initPopupSystem() {
  window.package = function(fun, type, content) {
    switch (fun) {
      case "popup":
        if (!document.querySelector(".popup")) {
          const elem = document.createElement("div");
          elem.classList.add("popup");
          document.body.appendChild(elem);
        }
        showPopup(type, content);
        break;
      case "remove":
        removeElement(type, content);
        break;
      default:
        return 0;
    }
  };

  function showPopup(type, content) {
    const popupContainer = document.querySelector(".popup");
    if (!popupContainer) return;

    // Set appropriate icon
    const icons = {
      danger: '<iconify-icon icon="solar:danger-bold" class="icon icon_danger"></iconify-icon>',
      warning: '<iconify-icon icon="ic:round-warning" class="icon icon_warning"></iconify-icon>',
      default: '<iconify-icon icon="icon-park-solid:success" class="icon icon_success"></iconify-icon>'
    };
    icon = icons[type] || icons.default;

    // Clear existing alerts
    const existingAlerts = document.querySelectorAll(".alert");
    if (existingAlerts.length > 0) {
      existingAlerts[0].remove();
    }

    // Create new alert
    const alertId = `alert_${existingAlerts.length}`;
    const alertElem = document.createElement("section");
    alertElem.classList.add("alert");
    alertElem.id = alertId;
    alertElem.innerHTML = `
      <a href="javascript:void(0)" class="close" title="close" 
         onclick="package('remove', 'popup', '${existingAlerts.length}')">
        <i class="fa fa-times"></i>
      </a>
      <article>
        <h3 class="title">${icon}${type}</h3>
        <p>${content}</p>
      </article>
    `;
    
    popupContainer.appendChild(alertElem);
  }

  function removeElement(type, ele) {
    if (type === "popup") {
      const element = document.getElementById(`alert_${ele}`);
      if (element) element.remove();
      
      if (!document.querySelector(".alert")) {
        const popup = document.querySelector(".popup");
        if (popup) popup.remove();
      }
    }
  }
}

// ======================
// MOBILE CAROUSEL
// ======================
function initMobileCarousel() {
  function setupCarousel() {
    if (isMobileDevice()) {
      $(".section_3 .cards").addClass("owl-carousel-active");
      $('.owl-carousel').owlCarousel({
        loop: true,
        margin: 10,
        nav: false,
        autoplay: true,
        responsive: { 0: { items: 1 } }
      });
    }
  }

  window.addEventListener("resize", setupCarousel);
  setupCarousel();
}

// ======================
// DOCUMENT READY
// ======================
$(document).ready(function() {
  initPopupSystem();
  initScrollAnimations();
  initMobileCarousel();
});