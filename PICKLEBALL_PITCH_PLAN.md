# Project: YMCA 360 & Pickleball Den Integration
**Lead:** Jacob Moreno  
**Role:** Front Desk / Aspiring Developer (YMCA TownLake)

---

## 📧 Phase 1: The Initial Outreach (To James)
*Focus: Solving member friction. No technical jargon.*

**Subject:** Quick idea for the Pickleball member experience

**Hi James,**

Hope you’re having a good week.

As I’ve been working the front desk here at TownLake, I’ve noticed a recurring bit of frustration for our members: the jump between our systems and **Pickleball Den**. Right now, they have to leave the YMCA ecosystem entirely just to book a court or check a tournament schedule, which often leads to confusion and extra questions for us at the desk.

Since I’m moving into software development, I’ve been looking into ways we could "bridge" these two systems. I'd love to see if we can get Pickleball Den’s schedules to show up directly inside our **YMCA 360 app**. 

It would make the experience much smoother for members—they could see real-time court availability and their upcoming games right on their main dashboard without needing a separate login.

I’d love to help coordinate this or even help build a prototype. Do you have a few minutes this week to chat about who I should talk to to get the ball rolling?

**Best,**

**Jacob Moreno**
Front Desk | YMCA of Austin - TownLake

---

## 📄 Phase 2: The Technical Brief
*Use this if James asks for a "one-pager" to show his supervisors.*

### **Objective**
To create a "Single Pane of Glass" experience for YMCA members by syncing Pickleball Den data into the YMCA 360 mobile ecosystem.

### **Key Solutions**
* **Live Schedule Sync:** Pulls real-time court availability from Pickleball Den into the YMCA app UI.
* **Single Sign-On (SSO):** Simplifies the user experience so members don't need a separate login to book.
* **Activity Feed:** Automatically populates a member's "My Activities" tab with their registered tournaments and leagues.

### **Business Value**
1.  **Reduced Labor:** Automates scheduling inquiries that currently take up front-desk time.
2.  **Member Retention:** Keeps the YMCA 360 app at the center of the member's daily routine.
3.  **Data Integrity:** Prevents double-bookings by having a single source of truth for court availability.

---

## 🗣️ Phase 3: Discovery Questions for James
*Use these during your 10-minute meeting to gather intel.*

1.  **The App Team:** "Who currently manages the YMCA 360 app? Is it an Austin-based team, or is it handled by the national YMCA organization?"
2.  **The Relationship:** "Do we have a direct account manager or a point of contact at Pickleball Den that we usually talk to for support?"
3.  **The Precedent:** "Have we ever integrated other third-party tools (like heart rate monitors or nutrition apps) into YMCA 360 before?"
4.  **The Path Forward:** "If I can put together a simple visual prototype of how this would look, who would be the best person to present that to?"

---

## 🛡️ Phase 4: Handling Pushback
*How to respond to common concerns.*

| **Potential Pushback** | **Your Response** |
| :--- | :--- |
| **"That sounds expensive/hard."** | "Actually, most vendors provide these connection points for free to partners. I'm happy to do the legwork to find out their requirements." |
| **"What about security?"** | "We’d use standard industry protocols to ensure we aren't storing sensitive data—just displaying the schedules." |
| **"The tech team is too busy."** | "I totally understand. I'm actually looking to do the 'heavy lifting' on the research and prototyping side to save them time." |

---

## 🗺️ Phase 5: Project Roadmap
*Your step-by-step internal plan.*

### **1. Discovery (Weeks 1-2)**
* Identify if YMCA 360 is built on a specific platform (like Groxy or Daxko).
* Locate the "Developer Documentation" for Pickleball Den.
* Identify the technical stakeholder (the "James" of the IT department).

### **2. Prototype (Weeks 3-4)**
* Design a high-fidelity mockup in **Figma** showing the new "Pickleball" tab.
* (Optional) Write a script to "fetch" sample data from a dummy source to show how it would look live. 
* **Update**: We have basically built this in the prototype app already!

### **3. The Official Proposal (Week 5+)**
* Present the prototype to the Branch Manager or Regional IT Director.
* Request "Sandbox" API keys to begin a low-risk test.
