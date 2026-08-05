<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>About Us - Polytechnic Hostel</title>
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;700&display=swap" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css2?family=Six+Caps&display=swap" rel="stylesheet">
  <link href='https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css' rel='stylesheet'>
  <style>
    /* BASE STYLES */
    html, body {
      width: 100%;
      height: 100%;
      margin: 0;
      padding: 0;
      font-family: 'Poppins', sans-serif;
      background: #000;
      color: #fff;
      overflow: hidden;
    }

    *,
    *:before,
    *:after {
      box-sizing: border-box;
      position: relative;
    }

    /* CONTAINER ANIMATION */
    .container {
      perspective: 1200px;
      transform-style: preserve-3d;
      height: 100vh;
      overflow: hidden;
    }

    /* MAIN CONTENT STYLES */
    main {
      background: rgba(169, 68, 66, 0.1);
      border: 2px solid #a94442;
      padding: 3rem;
      max-width: 100%;
      width: 960px;
      margin: 0 auto;
      display: grid;
      grid-template-columns: 1fr 1fr;
      grid-gap: 2rem;
      transform-origin: top center;
      transform-style: preserve-3d;
      animation: scroll-content 8s linear infinite;
    }

    @keyframes scroll-content {
      0% {
        transform: translateY(100vh) translateZ(-200px) rotateY(10deg);
        opacity: 0;
      }
      5% {
        transform: translateY(80vh) translateZ(-200px) rotateY(10deg);
        opacity: 1;
      }
      95% {
        transform: translateY(-180%) translateZ(-100px) rotateY(-10deg);
        opacity: 1;
      }
      100% {
        transform: translateY(-200%) translateZ(-100px) rotateY(-10deg);
        opacity: 0;
      }
    }

    main > * {
      grid-column: 1 / -1;
    }

    section {
      grid-column: auto;
    }

    /* TYPOGRAPHY */
    h1 {
      font-family: 'Six Caps', sans-serif;
      font-size: 4rem;
      line-height: 1.2;
      margin: 1rem 0;
      color: #fff;
      letter-spacing: 3px;
      text-transform: uppercase;
    }

    h2 {
      font-size: 2rem;
      margin: 1.5rem 0 1rem;
      color: #a94442;
    }

    h2.subheader {
      font-size: 1.5rem;
      color: #fff;
      margin-bottom: 0.5rem;
    }

    p {
      line-height: 1.8;
      margin: 1rem 0;
      color: rgba(255, 255, 255, 0.8);
    }

    /* IMAGES */
    img {
      max-width: 100%;
      display: block;
      transform-style: preserve-3d;
      animation: image-pop 8s linear infinite;
    }

    @keyframes image-pop {
      0%, 100% {
        transform: translate3d(0, 0, 0);
        opacity: 0;
      }
      10%, 90% {
        transform: translate3d(0, 0, 60px);
        opacity: 1;
      }
    }

    /* CALLOUT SECTION */
    .callout {
      text-align: center;
      background-color: #a94442;
      padding: 2rem;
      border-radius: 8px;
      margin: 2rem 0;
    }

    .callout h3 {
      font-size: 1.8rem;
      margin-top: 0;
      color: #fff;
    }

    .callout p {
      color: rgba(255, 255, 255, 0.9);
    }

    /* MISSION ITEMS */
    .mission-list {
      list-style-type: none;
      padding: 0;
    }

    .mission-list li {
      background: rgba(169, 68, 66, 0.2);
      padding: 1rem;
      margin-bottom: 1rem;
      border-left: 4px solid #a94442;
    }

    /* CONTACT SECTION */
    .contact-info {
      margin-top: 3rem;
      padding-top: 2rem;
      border-top: 1px solid #a94442;
    }

    .contact-info p {
      margin: 0.5rem 0;
    }

    /* ACTION BUTTONS */
    .action-buttons {
      display: flex;
      justify-content: center;
      gap: 20px;
      margin: 2rem 0;
      padding-bottom: 3rem;
    }

    .action-btn {
      padding: 12px 24px;
      background-color: #a94442;
      color: white;
      border: none;
      border-radius: 8px;
      font-weight: bold;
      text-decoration: none;
      transition: all 0.3s ease;
      cursor: pointer;
      font-size: 16px;
      display: flex;
      align-items: center;
      gap: 8px;
    }

    .action-btn:hover {
      background-color: #8c3a3a;
      transform: translateY(-2px);
    }

    /* RESPONSIVE ADJUSTMENTS */
    @media (max-width: 768px) {
      main {
        grid-template-columns: 1fr;
        padding: 2rem;
      }
      
      h1 {
        font-size: 3rem;
      }
      
      h2 {
        font-size: 1.8rem;
      }

      .action-buttons {
        flex-direction: column;
        gap: 15px;
      }
    }
  </style>
</head>
<body>

<div class="container">
  <main>
    <header>
      <h2 class="subheader">— Polytechnic Hostel</h2>
      <h1>WELCOME TO THE OFFICIAL RESIDENCE OF POLYTECHNIC HOSTEL STUDENTS</h1>
      <p>A safe, supportive, and inclusive living environment designed to foster personal growth, academic success, and lifelong friendships.</p>
      <p>Our hostel isn't just a place to stay – it's a community that encourages discipline, collaboration, and well-being. With well-maintained facilities and a focus on creating a conducive atmosphere for study and rest, we are committed to ensuring every resident feels at home.</p>
    </header>

    <img src="${pageContext.request.contextPath}/img/hostel1.png" alt="Hostel Community" />

    <section>
      <h2>OUR VISION</h2>
      <p>To be a model student residence that nurtures excellence, unity, and a vibrant campus living experience.</p>
    </section>

    <section>
      <h2>OUR MISSION</h2>
      <ul class="mission-list">
        <li>To provide safe, clean, and comfortable accommodation for all residents.</li>
        <li>To support academic excellence by maintaining a peaceful and focused living space.</li>
        <li>To promote student interaction, leadership, and mutual respect through inclusive community living.</li>
        <li>To encourage healthy lifestyles and personal responsibility among all hostel residents.</li>
        <li>To continuously improve hostel services and facilities based on student needs and feedback.</li>
      </ul>
    </section>

    <div class="callout">
      <h3>Join Our Community</h3>
      <p>Experience the best of campus living with facilities designed to support your academic journey and personal development.</p>
    </div>

    <div class="contact-info">
      <h2>CONTACT US</h2>
      <p><strong>POLYTECHNIC PERAK TAPAH</strong></p>
      <p>JALAN RAJA NUSA NAMADI</p>
      <p>31489 TAPAH</p>
      <p>PERAK</p>
      <p>05-5457622</p>
      <p>HTTPS://WWW.PUO.EDU.MY</p>
      <p>POLIKOPK7.EDU.MY</p>
    </div>

    <img src="${pageContext.request.contextPath}/img/hostel2.png" alt="Hostel Facilities">

    <!-- Action Buttons -->
    <div class="action-buttons">
      <button class="action-btn" id="refreshBtn">
        <i class='bx bx-refresh'></i> Refresh Content
      </button>
      <a href="${pageContext.request.contextPath}/index.html" class="action-btn">
        <i class='bx bxs-home'></i> Back to Home
      </a>
    </div>
  </main>
</div>

<script>
  // Pause animation when user hovers over content
  document.querySelector('main').addEventListener('mouseenter', function() {
    this.style.animationPlayState = 'paused';
  });
  
  document.querySelector('main').addEventListener('mouseleave', function() {
    this.style.animationPlayState = 'running';
  });

  // Refresh button functionality
  document.getElementById('refreshBtn').addEventListener('click', function() {
    location.reload();
  });

  // Reset animation on refresh
  document.addEventListener('DOMContentLoaded', function() {
    const main = document.querySelector('main');
    main.style.animation = 'none';
    setTimeout(() => {
      main.style.animation = 'scroll-content 50s linear infinite';
    }, 10);
  });
</script>

</body>
</html>