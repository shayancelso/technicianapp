import { MemberType, Priority, WOStatus } from '@/constants/enums';

export interface WorkOrder {
  id: string;
  woNumber: string;
  priority: Priority;
  status: WOStatus;
  contractName: string;
  location: string;
  assetName: string;
  aptTimer: string;
  rrtTimer: string;
  jctTimer: string;
}

export interface WorkOrderDetail {
  woNumber: string;
  status: WOStatus;
  priority: Priority;
  bookedBy: string;
  rrt: string;
  jct: string;
  appointmentDate: string;
  contract: string;
  paymentStatus: string;
  assets: string;
  location: string;
  description: string;
  specialInstruction: string;
  photosCount: number;
  notesCount: number;
  historyCount: number;
  materialsCount: number;
  estimationCount: number;
}

export interface TeamMemberDetail {
  id: string;
  name: string;
  empId: string;
  designation: string;
  trade: string;
  memberType: MemberType;
  activeDays: number;
  activeHours: number;
  isPunchedIn: boolean;
  punchInTime: string;
  currentTask: string;
}

export interface TeamMember {
  id: string;
  name: string;
  empId: string;
  designation: string;
  memberType: MemberType;
  joinedAt: string;
  isPunchedIn: boolean;
}

export interface Technician {
  id: string;
  name: string;
  empId: string;
  trade: string;
  designation: string;
  memberType: MemberType;
  client: string;
  contract: string;
  isOnDuty: boolean;
}

export interface ProfileField {
  label: string;
  value: string;
}

export interface StarData {
  stars: number;
  count: number;
}
