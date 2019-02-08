---
date: 2019-02-07T00:00:00+00:00
title: Set Up A Custom Domain Email Inbox Using Tutanota
description: At the time of writing, Tutanota premium costs €12 per year. This is not a sponsored post. I just think Tutanota is a great product.
tags:
  - email
  - security
  - DNS
weight: -210
---

# Why you should care

[tutanota.com](https://tutanota.com/) Is a secure email service, which handles encryption of your emails and filters spam for you. The project is open source [https://github.com/tutao/tutanota](https://github.com/tutao/tutanota), GDPR compliant [https://tutanota.com/blog/posts/gdpr-compliant-email](https://tutanota.com/blog/posts/gdpr-compliant-email), and available on [Android](https://play.google.com/store/apps/details?id=de.tutao.tutanota&hl=en) as well as [iOS](https://itunes.apple.com/ca/app/tutanota/id922429609?mt=8).

There are a lot of other email providers out there, too many to count. Just search them up on your favourite search engine. However, the purpose of this is to avoid the titanic email providers in Google's gmail, Microsoft's Outlook, and Yahoo's... yahoo email. These are all free services, but ultimately it means that the user is being mined for their data. All of these providers allow ads into your inbox based on your data. Just like everyone is annoyed by junk mail in their physical mail boxes, we should be equally annoyed by ads in our inbox.

Tutanota cares about protecting the user's data. The servers powering it are kept in Germany (take _that_ Patriot Act), emails are encrypted at rest and in transit, and two facter authentication is supported.

You can use Tutanota for free. But if you want to support privacy on the internet, the price of €12 per year is not too steep. Or, if you want to follow a quick guide which will help you set up an email inbox using your own custom domain, then this post is targeted at you.

## Some limitations worth noting

Tutanota doesn't support [DMARC](https://dmarc.org/) for custom domain email addresses. If you just use the standard @tutanota.com, however, DMARC will work out of the box.

Not every two facter authentication method you would like is supported. If you prefer SMS, or YubiKey, too bad. You can only use TOTP (which will likely be to Google Authenticator.)

# Pre-amble over, the Guide

I'm going to assume you already own your own domain. If you don't I'd recommend AWS Route53, or Google Cloud DNS. They're both easy to use, and rock solid as DNS providers.

## Sign up for an account
[ https://mail.tutanota.com/signup](https://mail.tutanota.com/signup)

If you are willing to pay, pick Premium. If you don't want to pay, disregard the rest of the guide and enjoy your free, private email inbox.

### Create the required DNS records

Create an MX record which points your domain to Tutanota's mail servers, and a fake SPF record which allows Tutanota to send emails on your domain's behalf.

<table>
  <tr>
   <th>
    Name
   </th>
   <th>
    Type
   </th>
   <th>
    Value
   </th>
   <th>
    TTL
   </th>
  </tr>
  </tr>
   <td>
    your-domain.com
   </td>
   <td>
    MX
   </td>
   <td>
    1 mail.tutanota.de
   </td>
   <td>
    86400
   </td>
  </tr>
  </tr>
   <td>
    your-domain.com
   </td>
   <td>
    TXT
   </td>
   <td>
    "v=spf1 include:spf.tutanota.de -all"
   </td>
   <td>
    86400
   </td>
  </tr>
</table>

### Configure your Tutanota account to use a custom domain

1. Login
2. Settings > [global settings](https://mail.tutanota.com/settings/global) > Custom email domains > add your-domain.com
3. Settings > [user management](https://mail.tutanota.com/settings/users) > Click your user > create an email alias for your new domain

Hurrah, you can now send and receive emails using your own domain. And it probably took less than 10 minutes.

Also, use [Signal](https://signal.org/).
