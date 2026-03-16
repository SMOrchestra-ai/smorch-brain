# VSL Landing Page Structure: SMO Webinar Registration

Single-file HTML registration page for webinar signup with VSL-style design.

---

## Design System Reference

**Colors (SMO Brand):**
- Background: #000000 (pure black)
- Accent: #FF6600 (orange)
- Card background: #111111 (dark gray)
- Text primary: #FFFFFF (white)
- Text secondary: #CCCCCC (light gray)
- Accent light: #FF9933 (lighter orange for hover states)

**Typography:**
- Font family: Inter, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif
- Headlines: 36-48px, bold, #FFFFFF
- Subheadings: 24-28px, normal weight, #FFFFFF
- Body: 16-18px, #CCCCCC
- Button text: 16px bold, #000000 on #FF6600

**Spacing:**
- Section padding: 60px top/bottom (responsive: 40px on mobile)
- Horizontal padding: 20px (mobile), 40px (tablet), 60px (desktop)
- Card gaps: 24px
- Line height: 1.6 (body text), 1.4 (headlines)

**Responsive breakpoints:**
- Mobile: max-width 640px
- Tablet: 641px - 1024px
- Desktop: 1025px+

---

## HTML Structure (Section by Section)

### 1. NAVIGATION BAR
```html
<nav class="navbar">
  <div class="navbar-content">
    <div class="logo">SMOrchestra.ai</div>
    <button class="cta-button">Register Now</button>
  </div>
</nav>
```
**Design notes:**
- Sticky (stays at top when scrolling)
- Simple: logo left, CTA button right
- On mobile: stack or hide logo, keep CTA button

---

### 2. HERO SECTION
```
[Headline]
"Signal-Based Selling Replaces Coffee Meetings"

[Subheading]
"The 3 secrets enterprise founders are using to compress sales cycles 40%"

[Event Details]
Thursday, [Date] | 2:00 PM GST | 60 minutes

[Video Placeholder]
(16:9 aspect ratio, dark background)

[CTA Button]
"Register Now - Free"
```

**Design notes:**
- Full viewport height (min-height: 100vh on desktop, 70vh on mobile)
- Centered content
- Video placeholder (640x360px minimum)
- Button is large and obvious (40px height, wide padding)
- Countdown timer positioned below video

---

### 3. COUNTDOWN TIMER
```
Days  Hours  Minutes  Seconds
[00]  [12]   [34]     [56]

"Registration closes Friday at 11:59pm"
```

**Design notes:**
- JavaScript-driven (countdown to event or registration deadline)
- Large numbers (24-32px)
- Color: orange (#FF6600) for the numbers
- Update every second

**JavaScript:**
```javascript
function startCountdown(targetDate) {
  const countdownInterval = setInterval(() => {
    const now = new Date().getTime();
    const distance = new Date(targetDate).getTime() - now;

    const days = Math.floor(distance / (1000 * 60 * 60 * 24));
    const hours = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
    const minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
    const seconds = Math.floor((distance % (1000 * 60)) / 1000);

    document.getElementById('countdown').innerHTML =
      `${days}d ${hours}h ${minutes}m ${seconds}s`;

    if (distance < 0) clearInterval(countdownInterval);
  }, 1000);
}
```

---

### 4. "WHAT YOU'LL LEARN" SECTION

```
[Section Title]
What You'll Learn

[Three Cards - One Per Secret]

Card 1:
[Icon: 1]
Secret 1: The Pre-Meeting Kill Sheet
Demonstrates authority BEFORE the first conversation
(Framework preview, not full teach-out)

Card 2:
[Icon: 2]
Secret 2: The 30-Second Trust Flip
Converts skeptics in 30 seconds on your page, email, or video
(Framework preview, not full teach-out)

Card 3:
[Icon: 3]
Secret 3: The WSO Cultural Accelerator
Maps buying signals to cultural behaviors in Gulf markets
(Framework preview, not full teach-out)
```

**Design notes:**
- 3-column grid on desktop, 1-column on mobile
- Each card: dark background (#111111), border: 1px solid #FF6600
- Icon circle: 60px, background #FF6600, number white
- Card height: min-height 200px
- Padding inside card: 24px
- Hover state: border becomes #FF9933, subtle scale transform (1.02x)

---

### 5. SPEAKER CREDIBILITY SECTION

```
[Section Title]
Meet Your Instructor

[Speaker Image - 200x200px]

[Speaker Name]
Mamoun Alamouri

[Title + Company]
CEO & Founder, SMOrchestra.ai

[Bio + Credentials]
20 years B2B SaaS enterprise tech (Cisco, Avaya, Uniphore)
Built signal-based engines for 40+ MENA companies
Converts cold outreach to 11 deals/year (vs. 2 from coffee meetings)

[Authority Stat]
"From 2 deals/year through relationships to 11 deals/year through signal-based
selling. Now teaching 40+ companies the same system."
```

**Design notes:**
- Image: circular, 200px on desktop (150px on mobile)
- Text centered, column layout
- Bio font: 16-18px, #CCCCCC
- Authority stat: highlighted box with border-left: 4px solid #FF6600
- Background: optional dark card background (#111111) with padding

---

### 6. SOCIAL PROOF / AUTHORITY SOURCES

```
[Section Title]
What You'll Discover Is Backed By:

[Authority Cards - Grid Layout]

Card 1:
[Book/Source Icon]
"The First 90 Days"
Michael Watkins
Framework + methodology

Card 2:
[Research Icon]
Gong Sales Research
47% of buyers prefer systematic communication
Data

Card 3:
[Framework Icon]
Cynefin Framework
Pattern recognition in complex markets
Model

Card 4:
[Platform Icon]
Russell Brunson Perfect Webinar
Proven webinar methodology
Methodology

[Case Study Reference]
"12 qualified deals in 90 days"
Fortune 500 company, MENA region
Proof of implementation
```

**Design notes:**
- 2x2 grid on desktop, 1-column on mobile
- Each card: 160x160px (smaller than what-you-learn cards)
- Icon area: 60x60px
- Title: 14px bold
- Description: 12px
- Hover state: background becomes #FF6600, text becomes #000000

---

### 7. REGISTRATION CTA SECTION

```
[Section Title]
Ready to Shift Your Sales?

[Subtext]
Limited spots available. Last year we filled up in 4 days.

[CTA Button - Large]
"Register Now - Free"

[Form (Optional - Embedded or External)]
First Name
Email
Company
Phone (optional)

[Fine Print]
"You'll get the 90-Day Playbook immediately after registration.
Check your email. (Don't forget to check spam.)"
```

**Design notes:**
- Full-width button (responsive, 100% on mobile, max-width 400px on desktop)
- Button height: 50px
- Font: 18px bold
- Hover state: background becomes #FF9933, slight shadow
- Form: max-width 500px, centered
- Form inputs: full-width, padding: 12px 16px, border: 1px solid #FF6600
- Submit button: same as main CTA

**Form integration:**
- If using GoHighLevel: embed GHL form with same styling
- If using external form: iframe with white-label option
- Or: simple form with action="/subscribe" method="POST"

---

### 8. FOOTER

```
[Links Row]
Privacy Policy | Terms of Service | Contact

[Copyright]
© 2026 SMOrchestra.ai. All rights reserved.

[Social Links - Optional]
LinkedIn | Twitter | Email
```

**Design notes:**
- Small text: 12-14px, #999999
- Links hover: color becomes #FF6600
- Padding: 40px top/bottom, centered
- Border-top: 1px solid #222222

---

## Mobile Responsive Notes

**Breakpoints and changes:**
- **Below 640px (mobile):**
  - Hero height: 70vh (not 100vh)
  - Headline: 28-32px (not 36-48px)
  - Subheading: 18-20px (not 24-28px)
  - Video: 100% width, auto height
  - What-you-learn cards: 1 column, full width with margin
  - Speaker section: image 120px (not 200px)
  - Authority cards: 1 column instead of 2x2
  - Button: 100% width
  - Navbar: logo hidden or very small, CTA button full-width or icon-only

- **640px - 1024px (tablet):**
  - Hero height: 80vh
  - What-you-learn cards: 2 columns (or responsive 1-2)
  - Authority cards: 2x2 grid
  - Padding: 30px
  - Speaker image: 160px

---

## HTML Template (Complete Single File)

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>[Event Name] - Webinar Registration</title>
  <style>
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
    }

    body {
      font-family: Inter, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
      background-color: #000000;
      color: #CCCCCC;
      line-height: 1.6;
    }

    /* NAVBAR */
    .navbar {
      position: sticky;
      top: 0;
      background-color: rgba(0, 0, 0, 0.95);
      border-bottom: 1px solid #222222;
      padding: 20px 0;
      z-index: 1000;
    }

    .navbar-content {
      max-width: 1200px;
      margin: 0 auto;
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding: 0 40px;
    }

    .logo {
      font-size: 18px;
      font-weight: bold;
      color: #FFFFFF;
    }

    /* CTA BUTTON */
    .cta-button {
      background-color: #FF6600;
      color: #000000;
      border: none;
      padding: 12px 24px;
      font-size: 14px;
      font-weight: bold;
      border-radius: 4px;
      cursor: pointer;
      transition: background-color 0.3s ease;
    }

    .cta-button:hover {
      background-color: #FF9933;
    }

    /* HERO SECTION */
    .hero {
      min-height: 100vh;
      display: flex;
      flex-direction: column;
      justify-content: center;
      align-items: center;
      text-align: center;
      padding: 60px 40px;
      background: linear-gradient(135deg, #000000 0%, #0F1923 100%);
    }

    .hero h1 {
      font-size: 48px;
      font-weight: bold;
      color: #FFFFFF;
      margin-bottom: 20px;
      line-height: 1.4;
    }

    .hero p {
      font-size: 24px;
      color: #CCCCCC;
      margin-bottom: 30px;
      max-width: 800px;
    }

    .event-details {
      font-size: 16px;
      color: #FF6600;
      margin-bottom: 40px;
      font-weight: 500;
    }

    .video-placeholder {
      width: 100%;
      max-width: 640px;
      aspect-ratio: 16/9;
      background-color: #111111;
      border: 2px solid #FF6600;
      margin-bottom: 40px;
      display: flex;
      align-items: center;
      justify-content: center;
      color: #CCCCCC;
      font-size: 18px;
    }

    /* COUNTDOWN */
    .countdown {
      display: flex;
      gap: 30px;
      justify-content: center;
      margin-top: 40px;
      font-size: 32px;
      font-weight: bold;
    }

    .countdown-item {
      display: flex;
      flex-direction: column;
      align-items: center;
    }

    .countdown-number {
      color: #FF6600;
      font-size: 36px;
    }

    .countdown-label {
      color: #999999;
      font-size: 12px;
      margin-top: 8px;
    }

    .countdown-text {
      margin-top: 20px;
      font-size: 14px;
      color: #FF6600;
    }

    /* SECTIONS */
    section {
      padding: 60px 40px;
      max-width: 1200px;
      margin: 0 auto;
    }

    section h2 {
      font-size: 36px;
      color: #FFFFFF;
      text-align: center;
      margin-bottom: 50px;
    }

    /* WHAT YOU'LL LEARN */
    .cards-grid {
      display: grid;
      grid-template-columns: repeat(3, 1fr);
      gap: 30px;
      margin-bottom: 40px;
    }

    .card {
      background-color: #111111;
      border: 1px solid #FF6600;
      padding: 30px;
      border-radius: 4px;
      min-height: 200px;
      display: flex;
      flex-direction: column;
      justify-content: flex-start;
      transition: all 0.3s ease;
    }

    .card:hover {
      border-color: #FF9933;
      transform: scale(1.02);
    }

    .card-icon {
      width: 60px;
      height: 60px;
      background-color: #FF6600;
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
      color: #000000;
      font-size: 24px;
      font-weight: bold;
      margin-bottom: 20px;
    }

    .card h3 {
      font-size: 18px;
      color: #FFFFFF;
      margin-bottom: 12px;
    }

    .card p {
      font-size: 14px;
      color: #CCCCCC;
    }

    /* SPEAKER SECTION */
    .speaker-section {
      text-align: center;
    }

    .speaker-image {
      width: 200px;
      height: 200px;
      border-radius: 50%;
      background-color: #111111;
      border: 2px solid #FF6600;
      margin: 0 auto 30px;
      object-fit: cover;
    }

    .speaker-name {
      font-size: 24px;
      font-weight: bold;
      color: #FFFFFF;
      margin-bottom: 10px;
    }

    .speaker-title {
      font-size: 16px;
      color: #FF6600;
      margin-bottom: 20px;
    }

    .speaker-bio {
      font-size: 16px;
      color: #CCCCCC;
      margin-bottom: 30px;
      max-width: 600px;
      margin-left: auto;
      margin-right: auto;
      line-height: 1.8;
    }

    .authority-stat {
      background-color: #111111;
      border-left: 4px solid #FF6600;
      padding: 20px;
      max-width: 600px;
      margin: 0 auto;
      font-size: 16px;
      font-style: italic;
      color: #FFFFFF;
    }

    /* AUTHORITY CARDS */
    .authority-grid {
      display: grid;
      grid-template-columns: repeat(2, 1fr);
      gap: 20px;
    }

    .authority-card {
      background-color: #111111;
      border: 1px solid #222222;
      padding: 20px;
      text-align: center;
      border-radius: 4px;
      transition: all 0.3s ease;
    }

    .authority-card:hover {
      background-color: #FF6600;
      color: #000000;
      border-color: #FF6600;
    }

    .authority-card:hover h4,
    .authority-card:hover p {
      color: #000000;
    }

    .authority-icon {
      font-size: 28px;
      margin-bottom: 12px;
    }

    .authority-card h4 {
      font-size: 14px;
      color: #FFFFFF;
      margin-bottom: 8px;
    }

    .authority-card p {
      font-size: 12px;
      color: #CCCCCC;
    }

    /* REGISTRATION SECTION */
    .registration-section {
      text-align: center;
      background-color: #111111;
      border: 1px solid #FF6600;
      padding: 60px 40px;
      border-radius: 4px;
    }

    .registration-section h2 {
      margin-bottom: 20px;
    }

    .registration-subtext {
      font-size: 16px;
      color: #FF6600;
      margin-bottom: 40px;
    }

    .large-cta-button {
      background-color: #FF6600;
      color: #000000;
      border: none;
      padding: 16px 40px;
      font-size: 18px;
      font-weight: bold;
      border-radius: 4px;
      cursor: pointer;
      transition: all 0.3s ease;
      max-width: 400px;
      width: 100%;
      margin: 0 auto 30px;
      height: 50px;
      display: block;
    }

    .large-cta-button:hover {
      background-color: #FF9933;
      transform: scale(1.05);
    }

    .registration-form {
      max-width: 500px;
      margin: 0 auto;
      text-align: left;
    }

    .form-group {
      margin-bottom: 20px;
    }

    .form-group label {
      display: block;
      font-size: 14px;
      color: #FFFFFF;
      margin-bottom: 8px;
    }

    .form-group input {
      width: 100%;
      padding: 12px 16px;
      background-color: #000000;
      border: 1px solid #FF6600;
      color: #FFFFFF;
      font-size: 14px;
      border-radius: 4px;
    }

    .form-group input:focus {
      outline: none;
      border-color: #FF9933;
      box-shadow: 0 0 0 2px rgba(255, 102, 0, 0.2);
    }

    .fine-print {
      font-size: 12px;
      color: #999999;
      margin-top: 20px;
    }

    /* FOOTER */
    footer {
      border-top: 1px solid #222222;
      padding: 40px;
      text-align: center;
      font-size: 12px;
      color: #999999;
    }

    footer a {
      color: #999999;
      text-decoration: none;
      margin: 0 10px;
    }

    footer a:hover {
      color: #FF6600;
    }

    /* RESPONSIVE */
    @media (max-width: 1024px) {
      .cards-grid {
        grid-template-columns: repeat(2, 1fr);
      }

      section {
        padding: 40px 30px;
      }
    }

    @media (max-width: 640px) {
      .navbar-content {
        padding: 0 20px;
      }

      .hero {
        min-height: 70vh;
        padding: 40px 20px;
      }

      .hero h1 {
        font-size: 28px;
      }

      .hero p {
        font-size: 18px;
      }

      .cards-grid {
        grid-template-columns: 1fr;
      }

      .authority-grid {
        grid-template-columns: 1fr;
      }

      .countdown {
        gap: 15px;
        font-size: 18px;
      }

      .countdown-number {
        font-size: 20px;
      }

      .speaker-image {
        width: 120px;
        height: 120px;
      }

      section h2 {
        font-size: 24px;
        margin-bottom: 30px;
      }

      .registration-section {
        padding: 40px 20px;
      }

      .logo {
        font-size: 14px;
      }
    }
  </style>
</head>
<body>

<!-- NAVBAR -->
<nav class="navbar">
  <div class="navbar-content">
    <div class="logo">SMOrchestra.ai</div>
    <button class="cta-button" onclick="document.querySelector('.registration-section').scrollIntoView({behavior: 'smooth'})">
      Register Now
    </button>
  </div>
</nav>

<!-- HERO SECTION -->
<section class="hero">
  <h1>Signal-Based Selling Replaces Coffee Meetings</h1>
  <p>The 3 secrets enterprise founders are using to compress sales cycles 40%</p>
  <div class="event-details">
    Thursday, [DATE] | 2:00 PM GST | 60 minutes
  </div>
  <div class="video-placeholder">
    [VSL Video will be embedded here]
  </div>
  <div class="countdown">
    <div class="countdown-item">
      <div class="countdown-number" id="days">00</div>
      <div class="countdown-label">Days</div>
    </div>
    <div class="countdown-item">
      <div class="countdown-number" id="hours">00</div>
      <div class="countdown-label">Hours</div>
    </div>
    <div class="countdown-item">
      <div class="countdown-number" id="minutes">00</div>
      <div class="countdown-label">Minutes</div>
    </div>
    <div class="countdown-item">
      <div class="countdown-number" id="seconds">00</div>
      <div class="countdown-label">Seconds</div>
    </div>
  </div>
  <div class="countdown-text">Registration closes Friday at 11:59pm</div>
</section>

<!-- WHAT YOU'LL LEARN -->
<section>
  <h2>What You'll Learn</h2>
  <div class="cards-grid">
    <div class="card">
      <div class="card-icon">1</div>
      <h3>Secret 1: The Pre-Meeting Kill Sheet</h3>
      <p>Demonstrates authority BEFORE the first conversation. Stop asking for time. Start showing proof.</p>
    </div>
    <div class="card">
      <div class="card-icon">2</div>
      <h3>Secret 2: The 30-Second Trust Flip</h3>
      <p>Converts skeptics in 30 seconds on your page, email, or video. Proof first. Relationship second.</p>
    </div>
    <div class="card">
      <div class="card-icon">3</div>
      <h3>Secret 3: The WSO Cultural Accelerator</h3>
      <p>Maps buying signals to cultural behaviors in Gulf markets. Specific frameworks for MENA selling.</p>
    </div>
  </div>
</section>

<!-- SPEAKER SECTION -->
<section class="speaker-section">
  <h2>Meet Your Instructor</h2>
  <img src="[speaker-image-url]" alt="Mamoun Alamouri" class="speaker-image">
  <div class="speaker-name">Mamoun Alamouri</div>
  <div class="speaker-title">CEO & Founder, SMOrchestra.ai</div>
  <div class="speaker-bio">
    20 years building B2B SaaS enterprise sales organizations at Cisco, Avaya, and Uniphore.
    Built signal-based sales engines for 40+ MENA companies. Converted cold outreach from 2 deals/year
    through relationships to 11 deals/year through systematic, signal-based methodology.
  </div>
  <div class="authority-stat">
    "I've tested and proven this works. Now I'm teaching the exact system so you can implement it in your business."
  </div>
</section>

<!-- SOCIAL PROOF / AUTHORITY -->
<section>
  <h2>This Is Backed By</h2>
  <div class="authority-grid">
    <div class="authority-card">
      <div class="authority-icon">📚</div>
      <h4>Gong Sales Research</h4>
      <p>47% of buyers prefer systematic communication over relationship-building</p>
    </div>
    <div class="authority-card">
      <div class="authority-icon">🎯</div>
      <h4>Cynefin Framework</h4>
      <p>Pattern recognition beats relationships in complex markets</p>
    </div>
    <div class="authority-card">
      <div class="authority-icon">🔬</div>
      <h4>Russell Brunson</h4>
      <p>Perfect Webinar methodology for belief shift and conversion</p>
    </div>
    <div class="authority-card">
      <div class="authority-icon">✅</div>
      <h4>Proven Results</h4>
      <p>12 qualified deals in 90 days for Fortune 500 company, MENA</p>
    </div>
  </div>
</section>

<!-- REGISTRATION CTA -->
<section class="registration-section">
  <h2>Ready to Shift Your Sales?</h2>
  <div class="registration-subtext">
    Limited spots available. Last year we filled up in 4 days.
  </div>
  <button class="large-cta-button">Register Now - Free</button>
  <form class="registration-form">
    <div class="form-group">
      <label for="first-name">First Name</label>
      <input type="text" id="first-name" name="first_name" required>
    </div>
    <div class="form-group">
      <label for="email">Email</label>
      <input type="email" id="email" name="email" required>
    </div>
    <div class="form-group">
      <label for="company">Company</label>
      <input type="text" id="company" name="company">
    </div>
    <div class="form-group">
      <label for="phone">Phone (optional)</label>
      <input type="tel" id="phone" name="phone">
    </div>
  </form>
  <div class="fine-print">
    You'll get the 90-Day Playbook immediately after registration. Check your email. (Don't forget to check spam!)
  </div>
</section>

<!-- FOOTER -->
<footer>
  <div>
    <a href="#privacy">Privacy Policy</a>
    <a href="#terms">Terms of Service</a>
    <a href="mailto:hello@smOrchestra.ai">Contact</a>
  </div>
  <div style="margin-top: 20px;">
    © 2026 SMOrchestra.ai. All rights reserved.
  </div>
</footer>

<!-- COUNTDOWN SCRIPT -->
<script>
function startCountdown() {
  // Set target date (update this to your event date/time)
  const targetDate = new Date("[EVENT DATE AND TIME]").getTime();

  const countdownInterval = setInterval(() => {
    const now = new Date().getTime();
    const distance = targetDate - now;

    const days = Math.floor(distance / (1000 * 60 * 60 * 24));
    const hours = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
    const minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
    const seconds = Math.floor((distance % (1000 * 60)) / 1000);

    document.getElementById('days').innerHTML = String(days).padStart(2, '0');
    document.getElementById('hours').innerHTML = String(hours).padStart(2, '0');
    document.getElementById('minutes').innerHTML = String(minutes).padStart(2, '0');
    document.getElementById('seconds').innerHTML = String(seconds).padStart(2, '0');

    if (distance < 0) {
      clearInterval(countdownInterval);
      document.querySelector('.countdown').innerHTML = 'Registration has closed.';
    }
  }, 1000);
}

// Start countdown when page loads
window.addEventListener('load', startCountdown);
</script>

</body>
</html>
```

---

## Integration Notes

**For GoHighLevel integration:**
- Embed GHL form in place of the manual form section
- Use GHL's white-label form option
- Keep styling consistent with the page

**For external registration links:**
- Use Calendly, Typeform, or similar
- Direct CTA button to external registration page
- Or embed via iframe with sandbox attributes

**For VSL video:**
- Upload video file (mp4, webm)
- Replace video-placeholder div with video tag
- Or use YouTube/Vimeo embed
- Ensure video is MUTED by default (autoplay policy)

**Customization fields:**
- [EVENT NAME] — Replace with actual event title
- [DATE] — Event date (e.g., "April 15, 2026")
- [speaker-image-url] — Link to speaker photo (200x200px minimum)
- [REGISTRATION LINK] — Link to GoHighLevel form or external registration
- [EVENT DATE AND TIME] — For countdown timer JavaScript
