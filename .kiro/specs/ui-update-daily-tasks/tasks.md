# Implementation Plan

- [x] 1. Remove prayer times section from main screen





  - Remove PrayerTimesWidget import and usage from MahdiTimer.dart
  - Clean up any unused prayer times service dependencies
  - _Requirements: 1_

- [x] 2. Remove 4-button grid section from main screen





  - Remove the GridView.count section from Buttons widget
  - Remove the _gridButton method and related popup functionality
  - Keep only the section header and calendar navigation button
  - _Requirements: 2_

- [x] 3. Modify "اعمال روزانه" title with full-width background bar





  - Update the section header container in Buttons widget to span full width
  - Apply distinctive background styling to visually separate from surrounding content
  - Ensure proper RTL layout and theme consistency
  - _Requirements: 3_

- [x] 4. Add text input field with "ثبت" button below title





  - Create a text input field below the "اعمال روزانه" title
  - Position "ثبت" button at bottom-right corner of the input field
  - Implement proper RTL text direction and Persian font support
  - _Requirements: 3_

- [x] 5. Implement save/edit functionality for daily tasks





  - Add state management for input text and edit mode
  - Implement save functionality that stores text and switches to display mode
  - Replace "ثبت" button with "ویرایش" button after saving
  - Add edit mode that restores text input and "ثبت" button
  - Integrate with existing NotesStore for data persistence
  - _Requirements: 3_

- [x] 6. Move calendar navigation to bottom-left with new styling





  - Modify AnimatedCalendarButton to remove background styling
  - Position button at bottom-left of screen
  - Update styling to show only text and arrow pointing toward next window
  - Ensure proper RTL layout and accessibility
  - _Requirements: 4_

- [x] 7. Add month-view calendar table to date window





  - Create a new calendar widget that displays a month view table
  - Implement proper Persian/Jalali calendar integration
  - Add date selection functionality with visual feedback
  - Position calendar at the top of the date window
  - _Requirements: 5_

- [x] 8. Implement date-specific task display functionality





  - Add functionality to display saved tasks for selected date below calendar
  - Create scrollable list area for tasks of the selected date
  - Integrate with existing NotesStore to fetch date-specific entries
  - Ensure proper Persian date formatting and RTL layout
  - _Requirements: 5_

- [x] 9. Remove third page from navigation flow





  - Update navigation to only include Main ↔ Date Window flow
  - Remove any references to the third page (days_page.dart if not needed)
  - Ensure clean navigation between main screen and date window
  - _Requirements: 5_
- [x] 10. Update main screen layout structure









- [ ] 10. Update main screen layout structure

  - Reorganize MahdiTimer widget layout to reflect new design
  - Remove StatisticsWidget and PoemCarousel if not needed in new design
  - Ensure proper spacing and visual hierarchy
  - Test responsive layout on different screen sizes
  - _Requirements: 1, 2, 3, 4_