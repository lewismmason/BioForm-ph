# LinearFit is a linear fit model. This class has the functionality to 
# Save and load models so that it can be used from different un-interacting programs
# The primary purpose is for pH meter calibration. The class can have it's system dynamically
# updated

# Dependencies
import matplotlib.pyplot as plt
from scipy import stats
import json

class LinearFit:

    #Private feilds
    # Saves the x and y dataset used to create the linear fit
    _x = []
    _y = []

    # linear fit parameters
    _r = None
    _p = None
    _slope = None
    _intercept = None
    _stderr = None


    def __init__(self, slope = None, intercept = None ):
        _slope = slope
        _intercept = intercept


    def set_params(self, slope, intercept):
        _slope = slope
        _intercept = intercept


    def _update_model(self):
        self._slope, self._intercept, self._r, self._p, self._stderr = stats.linregress(self._x,self._y)
        return True


    def _reset_model_params(self):
        # linear fit parameters
        self._r = None
        self._p = None
        self._slope = None
        self._intercept = None
        self._stderr = None


    # This function adds a new x-y pair to the model and updates all parameters based on that
    def add_data(self, x, y):
        self._x.append(x)
        self._y.append(y)
        if len(self._x) > 1 and len(self._y) > 1:
            self._update_model()
        return True


    # This function removes the most recent x-y pair and updates all parameters based on that
    def remove_most_recent(self):
        if len(self._x) > 0 and len(self._y) > 0:
            self._x.pop()
            self._y.pop()

            if len(self._x) > 1 and len(self._y) > 1:
                self._update_model()
            else:
                self._reset_model_params()

            return True
        else:
            return False


    # This evaluates a point with the fit
    def eval(self, val):
        try:
            ret = self._slope * val + self._intercept
            return ret
        except:
            print('Eval failed: Model parameters are not set')
            return None


    # This saves the current model into a json file so that it can be loaded from other programs
    def save_json_model(self, model_name):

        model = {
            'slope': self._slope,
            'intercept': self._intercept,
            'r': self._r,
            'x': self._x,
            'y': self._y,
            'stderr': self._stderr,
            'p': self._p
        }
        try:
            with open(model_name + '.json', 'w') as jf:
                json.dump(model, jf)
        except:
            print("Save may have failed, caught an exception")


    # This loads a pre-existing json model file
    def load_json_model(self, model_name):
        try:
            with open(model_name + '.json', 'r') as jf:
                model = json.load(jf)

                self._slope     = model['slope']
                self._intercept = model['intercept']
                self._r         = model['r']
                self._x         = model['x']
                self._y         = model['y']
                self._stderr    = model['stderr']
                self._p         = model['p']

        except:
            print("Load may have failed, caught an exception")


    def display_model(self):
        plt.scatter(self._x,self._y)
        try:
            model = list(map(self.eval,self._x))
            plt.plot(self._x,model)
            plt.show()
            print('r squared: ' + str(self._r**2))
        except:
            print('Display failed: Model parameters are not set')
            return None


    # def rsquared(self):
    #     try:
    #         ret = self._r**2
    #         return ret
    #     except:
    #         return None