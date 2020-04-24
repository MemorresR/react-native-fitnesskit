export const Permissions={
  StepCount: Platform.select({
  ios:"StepCount",
  android:"Step"
}),
Distance: Platform.select({
  ios:"DistanceWalkingRunning",
  android:"Distance"
}),
DistanceSwimming: Platform.select({
  ios:"DistanceSwimming",
  android:"" /*Only for ios */
}),
DistanceCycling: Platform.select({
  ios:"DistanceCycling",
  android:"" /*Only for ios */
}),
Energy: Platform.select({
  ios:"ActiveEnergyBurned",
  android:"Calorie"
}),
BasalEnergyBurned: Platform.select({
  ios:"BasalEnergyBurned",
  android:"" /*Only for ios */
}),
DietaryEnergy: Platform.select({
  ios:"DietaryEnergy",
  android:"" /*Only for ios */
}),
  HeartRate: "HeartRate",
}