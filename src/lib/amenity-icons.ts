import {
  AirVent,
  AlarmSmoke,
  Baby,
  Bath,
  BedDouble,
  BriefcaseMedical,
  Building2,
  Check,
  CircleParking,
  Coffee,
  CookingPot,
  Flame,
  Laptop,
  Microwave,
  MoveVertical,
  PawPrint,
  Refrigerator,
  Shirt,
  ShowerHead,
  Sun,
  Thermometer,
  Trees,
  Tv,
  UtensilsCrossed,
  WashingMachine,
  Waves,
  Wifi,
  Wind,
  type LucideIcon,
} from "lucide-react";
import { amenityCodeByLabel } from "@/lib/property-view";

/** Icon per amenity engine code; unknown codes fall back to a check mark. */
const ICONS: Record<string, LucideIcon> = {
  wifi: Wifi,
  parking: CircleParking,
  kitchen: CookingPot,
  tv: Tv,
  sauna: Flame,
  hot_tub: Bath,
  terrace: Sun,
  air_conditioning: AirVent,
  washing_machine: WashingMachine,
  coffee: Coffee,
  coffee_machine: Coffee,
  breakfast: UtensilsCrossed,
  pets: PawPrint,
  pet_friendly: PawPrint,
  pool: Waves,
  first_aid: BriefcaseMedical,
  extra_baby_bed: Baby,
  balcony: Building2,
  bathroom: Bath,
  workspace: Laptop,
  smoke_alarm: AlarmSmoke,
  "smoke alarm": AlarmSmoke,
  heating: Thermometer,
  hair_dryer: Wind,
  shower: ShowerHead,
  fridge: Refrigerator,
  microwave: Microwave,
  iron: Shirt,
  towels: Bath,
  linens: BedDouble,
  elevator: MoveVertical,
  garden: Trees,
  bbq: Flame,
};

export function amenityIconForCode(code: string): LucideIcon {
  return ICONS[code.trim().toLowerCase()] ?? Check;
}

/** Icon looked up from a translated amenity label. */
export function amenityIconForLabel(label: string): LucideIcon {
  const code = amenityCodeByLabel(label);
  return code ? amenityIconForCode(code) : Check;
}
