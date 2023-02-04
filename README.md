## API automation testing using Robot framework
### Project: InstituteManagement-API
  - Type of testing: API
  - Category: Automation
  - Language: Python
  - Framework: Robot framework
  - Execution period: 02-Feb-2023 to 04-Feb-2023
  - Modules:
    - Students
      - Test cases:
        - Register a new student using valid credentials (POST)
        - View the list of registered students along with their details (GET)
        - Return the detail's of a student by student id (GET)
        - Update student information by student id (PUT)
        - Update specific information of a student by student id using patch method (PATCH)
        - Delete a particular student along with activities by student id (DELETE)
    - Instructors
      - Test Cases:
          - Assign a new Instructor with valid credentials (POST REQUEST METHOD)
          - Views of all registered Instructors along with their details (GET REQUEST METHOD)
          - Return the detail's of an Instructor by instructor id (GET REQUEST METHOD)
          - Update Instructor information by Instructor id (PUT REQUEST METHOD)
          - Update specific records of an Instructor by Instructor id using patch method (PATCH REQUEST METHOD)
          - Delete Instructors by their id (DELETE REQUEST METHOD)
    - Courses
      - Test Cases:
        - Offer courses (POST HTTP REQUEST)
        - View the available offered courses (GET REQUEST METHOD)
        - Assign subjects to a particular course (POST HTTP REQUEST)
        - Search course & return the detail's course by id (GET HTTP METHOD)
        - Update the existing course after course offer (PUT HTTP REQUEST)
        - Delete courses by their id (DELETE HTTP REQUEST)
    - Subjects
      - Test Cases:
        - Assign subjects to a particular course (POST HTTP REQUEST)
        - View all offered subjects (GET REQUEST METHOD)
        - Find number of offered subjects under a particular course and returns the associated details of subjects by course id (GET HTTP METHOD)
        - Update the subject information (PUT HTTP REQUEST)
        - Delete subjects by their id (DELETE HTTP REQUEST)
    - Schedules
      - Test Cases:
        - Post class schedule along with associated details (POST HTTP REQUEST)
        - View all releases schedule and returns course, registered students and Instructor info (GET REQUEST METHOD)
        - Fetch schedule info by subject id (GET HTTP METHOD)
        - Update information of class schedule (PUT HTTP REQUEST)
        - Cancel class schedule by schedule id (DELETE HTTP REQUEST)

> [TestCases report](https://mehedihassanfaysal.github.io/InstituteManagementAPI-Testing-using-Robot_Framework/)

> [Test Cases](https://docs.google.com/spreadsheets/d/1o-rbeNnbT2etwogHMoksEhh_EMoH4uff/edit?usp=sharing&ouid=110212694347163662297&rtpof=true&sd=true)