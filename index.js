
import { NativeModules,Platform } from 'react-native';

const { RNIosSettingsBundle } = NativeModules;

export default {
    get: (key) =>
    {
        if(Platform == 'android')
            return callback([1,'it works only on ios!']);

        return RNIosSettingsBundle.getValByKey(key);
    }
};
