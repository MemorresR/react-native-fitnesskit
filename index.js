import { NativeModules } from 'react-native';

const { Fitnesskit } = NativeModules;
import {Permissions} from './js/Permissions';
export default Fitnesskit;
export const Permission = Object.freeze(Permissions)