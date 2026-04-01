---
title: "Integrating YubiKey FIDO2 With Authentik"
url: /integrating_yubikey_fido2_with_authentik
date: 2026-04-01T16:56:47+02:00
lastmod: 2026-04-01T16:56:47+02:00
draft: false
license: ""

tags: [linux, yubico, authentication, fido2, authentik, webauthn, mfa]
categories: [Linux, Homelab, CyberSecurity]
description: "This guide covers the implementation of hardware-backed authentication by integrating Yubico..."

featuredImagePreview: "/images/2026/integrating_yubikey_fido2_with_authentik/integrating_yubikey_fido2_with_authentik.png"


hiddenFromHomePage: false
hiddenFromSearch: false
twemoji: false
lightgallery: true
ruby: true
fraction: true
fontawesome: true
linkToMarkdown: true
rssFullText: false

toc:
    enable: true
    auto: true
comment:
    enable: true
code:
    copy: true
    maxShownLines: 50
math:
    enable: false
share:
    enable: true
    HackerNews: true
    Reddit: true
    VK: true
    Line: false
    Weibo: false
---
<!--more-->

This guide covers the implementation of hardware-backed authentication by integrating Yubico security keys into an Authentik environment. By leveraging FIDO2/WebAuthn, you can move beyond traditional TOTP codes toward a more resilient, phishing-resistant security model.


**Before beginning the configuration, ensure you have the following:**

- `An operational Authentik instance (latest version recommended)`
- `A Yubikey supporting FIDO2 (5 Series or Security Key series)`
- `An HTTPS-secured connection (WebAuthn requires a secure context to function)`

> Note: For the purposes of this guide, I will be using the Yubico Security Key C NFC

<div style="transform: rotate(90deg); width: 30%; margin: 0px auto;">
    {{< image 
        src="/images/2026/integrating_yubikey_fido2_with_authentik/Yubikey-c-nfc-Front.webp" 
        alt="Yubico Security Key C NFC"
    >}}
</div>

## Getting Started

<div style="width: 30%; margin: 10px auto;">
    {{< image 
        src="/images/2026/integrating_yubikey_fido2_with_authentik/yubico.png" 
        alt="Yubico" 
    >}}
</div>

For a long time, my standard workflow relied on traditional password authentication paired with TOTP (Time-based One-Time Passwords). While TOTP is a solid layer of defense, it still carries minor frictions and vulnerabilities to sophisticated phishing. To **level up** my security posture, I decided to transition to hardware-backed authentication.

## Configuration Steps

The first step is to register the hardware key to your user profile. This ensures that Authentik recognizes your specific device before you enforce it across your flows.

### Step 1: Enrolling Your Device

<div style="width: 100%; margin: 10px auto;">
    {{< image 
        src="/images/2026/integrating_yubikey_fido2_with_authentik/webauth.png" 
        alt="Enrolling Your Device"
    >}}
</div>

1. Navigate to Settings: Click on `Settings` icon.
2. MFA Devices: Locate the `MFA Devices` section in the sidebar or main menu.
3. Enroll New Device: Click on `Enroll` and select `WebAuthn Device` from the list of options.
4. Set a PIN: When prompted by your browser, you will likely be asked to provide a `PIN` for your security key. This adds an extra layer of "something you know" to your "something you have."
5. Tap the Key: When the prompt appears, `tap` the **Yubico Security Key C NFC** to finalize the registration.

Once successful, your key will appear in the list of active MFA devices, and you are ready to use it for authentication.

### Step 2: Configuring the Authentication Flow

Now that the device is enrolled, we need to tell Authentik to use it during the login process. This involves creating a WebAuthn Stage and binding it to your Authentication Flow.

Instead of building a new flow from scratch, we will modify the default-authentication-flow to streamline the process. We are going to remove the standard password-only requirement and focus on the MFA Validation stage to handle our Yubikey and TOTP.

By keeping both classes, Authentik will intelligently offer the WebAuthn prompt first if a key is detected, but still allow you to **"Switch to another method"** to use TOTP if you do not have your **Yubikey**. This provides the perfect balance of high security and a fallback safety net.

<div style="width: 100%; margin: 10px auto;">
    {{< image 
        src="/images/2026/integrating_yubikey_fido2_with_authentik/default-authentication-flow.png" 
        alt="Configuring the Authentication Flow"
    >}}
</div>

- **Adjusting Stage Bindings**

1. In the Authentik Admin interface, navigate to `Flows and Stages` > `Flows`.
2. Select the `default-authentication-flow`.
3. Go to the `Stage Bindings` tab.
4. Remove the Password Stage: Locate the binding for the password-only validation and remove it. We want the flow to move directly from identification to MFA validation.

- **Configuring MFA Validation**

1. Navigate to `Flows and Stages` > `Flows` and select your `default-authentication-flow`.
2. Go to the Stage Bindings tab.
3. Locate the `default-authentication-mfa-validation` entry and select `Edit Stage`.
4. Configure Device Classes: In the configuration window, look for the Stage-specific settings.
5. Select Devices slasses: Ensure only the following are selected:
    - `WebAuthn Authenticator (This enables your Yubikey)`
    - `TOTP Authenticator (This keeps your mobile app as a backup)`

<div style="width: 100%; margin: 10px auto;">
    {{< image 
        src="/images/2026/integrating_yubikey_fido2_with_authentik/devices_slasses.png" 
        alt="Devices slasses"
    >}}
</div>

6. Not configured action: `Force the user to configure an authenticator`.

<div style="width: 100%; margin: 10px auto;">
    {{< image 
        src="/images/2026/integrating_yubikey_fido2_with_authentik/configured_action.png" 
        alt="Configured action"
    >}}
</div>

7. Configuration stages: Ensure only the following are selected:
    - `default-authenticator-webauthn-setup (WebAuthn Authenticator Setup Stage)`
    - `default-authenticator-totp-setup (TOTP Authenticator Setup Stage)`

<div style="width: 100%; margin: 10px auto;">
    {{< image 
        src="/images/2026/integrating_yubikey_fido2_with_authentik/configuration_stages.png" 
        alt="Configuration stages"
    >}}
</div>

8. WebAuthn User verification: Select `User verification must occur`.

<div style="width: 100%; margin: 10px auto;">
    {{< image 
        src="/images/2026/integrating_yubikey_fido2_with_authentik/user_verification.png" 
        alt="WebAuthn User verification"
    >}}
</div>

### Step 3: Testing the Login Flow

<div style="width: 100%; margin: 10px auto;">
    {{< image 
        src="/images/2026/integrating_yubikey_fido2_with_authentik/login.png" 
        alt="Testing the Login Flow"
    >}}
</div>

Once you have updated your flows, it is time to verify that Authentik is correctly challenging for your hardware key.

1. Open an Incognito/Private Window: This ensures you are `not using an existing session`.
2. Access Your Authentik URL: Navigate to your login page.
3. The WebAuthn Prompt: Instead of a username field, your browser should immediately trigger `the security key prompt`.
4. Enter Your PIN: Enter the `PIN` you set for your Yubico Security Key C NFC.
5. Tap the Key: When the `key's LED begins to flash`, tap the gold contact point.
6. Success: Authentik identifies your account based on the resident credential stored on the Yubikey and logs you in instantly.

While the Yubikey is our primary "Level Up" method, it’s essential to ensure your TOTP (Time-based One-Time Password) backup is still active and working.

1. Open an Incognito/Private Window: This ensures you are `not using an existing session`.
2. Select "Try Another Method": If the browser immediately prompts for your security key/PIN, look for the option to `Try another method` or `Use a different device` in the Authentik UI.
3. The TOTP Prompt: Select your `TOTP Authenticator` from the list.
4. Scan to Verify: Authentik will display a `one-time QR code` on the screen.
    - Open your authenticator app on your phone
    - Use the Camera/Scanner within the app to scan the code
5. Instant Approval: Once scanned, the app sends the validation back to Authentik. The browser will automatically refresh and grant you access.

## Conclusion

By transitioning from a simple password/TOTP combo to a hardware-backed FIDO2 workflow, you have effectively **"leveled up"** your security. Using the Yubico Security Key C NFC not only speeds up the login process with a simple tap but also provides a physical barrier against remote phishing attacks.

Your Authentik instance is now a hardened gateway, ensuring that your services remain accessible only to you and your key.