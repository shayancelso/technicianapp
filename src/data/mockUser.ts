import { ProfileField, StarData } from '@/types/models';

export const mockUser = {
  displayName: 'S Sampath',
  designation: 'AC Technician',
  initials: 'SS',
} as const;

export const mockProfileFields: ProfileField[] = [
  { label: 'First Name', value: 'Sampath' },
  { label: 'Last Name', value: 'S' },
  { label: 'Mobile', value: '+971 50 123 4567' },
  { label: 'Email', value: 'sampath@reflexion.ae' },
  { label: 'Designation', value: 'AC Technician' },
  { label: 'Department', value: 'HVAC & Mechanical' },
];

export const mockOverallRating = 3.0;

export const mockStarBreakdown: StarData[] = [
  { stars: 5, count: 11 },
  { stars: 4, count: 3 },
  { stars: 3, count: 8 },
  { stars: 2, count: 4 },
  { stars: 1, count: 4 },
];
